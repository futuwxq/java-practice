<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8" content="">
<title>学生列表</title>
<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
<script type="text/javascript">
	$(function() {
		//datagrid初始化 
		$('#dataList')
				.datagrid(
						{
							title : '学生列表',
							iconCls : 'icon-more',//图标 
							border : true,
							collapsible : false,//是否可折叠的 
							fit : true,//自动大小 
							method : "post",
							// 							学生列表
							url : "StudentServlet?method=StudentList&t="
									+ new Date().getTime(),
							idField:'id', 
							singleSelect : false,//是否单选 
							pagination : true,//分页控件 
							rownumbers : true,//行号 
							sortName : 'id',
							sortOrder : 'DESC',
							remoteSort : false,
							columns : [ [
									{
										field : 'chk',
										checkbox : true,
										width : 50
									},
									{
										field : 'id',
										title : 'ID',
										width : 50,
										sortable : false
									},
									{
										field : 'sn',
										title : '学号',
										width : 150,
										sortable : true
									},
									{
										field : 'name',
										title : '姓名',
										width : 100
									},
									{
										field : 'sex',
										title : '性别',
										width : 100
									},
									{
										field : 'birthday',
										title : '出生日期',
										width : 200
									},
									{
										field : 'grade',
										title : '年级',
										width : 100
									},
									{
										field : 'major',
										title : '专业',
										width : 150
									},
									{
										field : 'headteacher',
										title : '班主任',
										width : 150

									},
									{
										field : 'clazz_id',
										title : '班级',
										width : 100,

										formatter : function(value, row, index) {
											if (row.clazzId) {
												var clazzList = $("#clazzList")
														.combobox("getData");
												for (var i = 0; i < clazzList.length; i++) {

													if (row.clazzId == clazzList[i].id)
														return clazzList[i].name;
												}
												return row.clazzId;
											} else {
												return 'not found';
											}
										}
									},

							] ],
							//比班级列显示先于导航栏
							toolbar : "#toolbar",
							onBeforeLoad : function() {
								try {
									$("#clazzList").combobox("getData")
								} catch (err) {
									preLoadClazz();
								}
							}
						});
		//设置分页控件 
		var p = $('#dataList').datagrid('getPager');
		$(p).pagination({
			pageSize : 10,//每页显示的记录条数，默认为10 
			pageList : [ 10, 20, 30, 50, 100 ],//可以设置每页记录条数的列表 
			beforePageText : '第',//页数文本框前显示的汉字 
			afterPageText : '页    共 {pages} 页',
			displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录',
		});
		//设置工具类按钮
		$("#add").click(function() {
			$("#addDialog").dialog("open");
		});
		//修改
		$("#edit").click(function() {
			var selectRows = $("#dataList").datagrid("getSelections");
			if (selectRows.length != 1) {
				$.messager.alert("消息提醒", "请选择一条数据进行操作!", "warning");
			} else {
				$("#editDialog").dialog("open");
			}
		});
		//删除
		$("#delete")
				.click(
						function() {
							var selectRows = $("#dataList").datagrid(
									"getSelections");
							var selectLength = selectRows.length;
							if (selectLength == 0) {
								$.messager.alert("消息提醒", "请选择数据进行删除!",
										"warning");
							} else {
								var numbers = [];
								$(selectRows).each(function(i, row) {
									numbers[i] = row.sn;
								});
								var ids = [];
								$(selectRows).each(function(i, row) {
									ids[i] = row.id;
								});
								$.messager
										.confirm(
												"消息提醒",
												"将删除与学生相关的所有数据，确认继续？",
												function(r) {
													if (r) {
														$
																.ajax({
																	type : "post",
																	url : "StudentServlet?method=DeleteStudent",
																	data : {
																		sns : numbers,
																		ids : ids
																	},
																	success : function(
																			msg) {
																		if (msg == "success") {
																			$.messager
																					.alert(
																							"消息提醒",

																							"删除成功!",
																							"info");
																			//刷新表格
																			$(
																					"#dataList")
																					.datagrid(
																							"reload");
																			$(
																					"#dataList")
																					.datagrid(
																							"uncheckAll");
																		} else {
																			$.messager
																					.alert(
																							"消息提醒",
																							"删除失败!",
																							"warning");
																			return;
																		}
																	}
																});
													}
												});
							}
						});
		//班级下拉框	  	
		function preLoadClazz() {
			$("#clazzList").combobox(
					{
						width : "150",
						height : "25",
						valueField : "id",
						textField : "name",
						multiple : false, //可多选
						editable : false, //不可编辑
						method : "post",
						url : "ClazzServlet?method=getClazzList&t="
								+ new Date().getTime() + "&from=combox",
						onChange : function(newValue, oldValue) {
						}
					});
		}

		//下拉框通用属性
		$("#add_clazzList, #edit_clazzList").combobox({
			width : "200",
			height : "30",
			valueField : "id",
			textField : "name",
			multiple : false, //可多选
			editable : false, //不可编辑
			method : "post",
		});

		$("#add_clazzList").combobox(
				{
					url : "ClazzServlet?method=getClazzList&t="
							+ new Date().getTime() + "&from=combox",
					onLoadSuccess : function() {
						//默认选择第一条数据
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
					}
				});

		$("#edit_clazzList").combobox(
				{
					url : "ClazzServlet?method=getClazzList&t="
							+ new Date().getTime() + "&from=combox",
					onLoadSuccess : function() {
						//默认选择第一条数据
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
					}
				});

		//设置添加学生窗口
		$("#addDialog")
				.dialog(
						{
							title : "添加学生",
							width : 650,
							height : 460,
							iconCls : "icon-add",
							modal : true,
							collapsible : false,
							minimizable : false,
							maximizable : false,
							draggable : true,
							closed : true,
							buttons : [
									{
										text : '添加',
										plain : true,
										iconCls : 'icon-user_add',
										handler : function() {
											var validate = $("#addForm").form(
													"validate");
											if (!validate) {
												$.messager
														.alert("消息提醒",
																"请检查你输入的数据!",
																"warning");
												return;
											} else {
												var clazzid = $(
														"#add_clazzList")
														.combobox("getValue");
												$
														.ajax({
															type : "post",
															url : "StudentServlet?method=AddStudent",
															data : $("#addForm")
																	.serialize(),
															success : function(
																	msg) {
																if (msg == "success") {
																	$.messager
																			.alert(
																					"消息提醒",
																					"添加成功!",
																					"info");
																	//关闭窗口
																	$(
																			"#addDialog")
																			.dialog(
																					"close");
																	//清空原表格数据

																	$("#add_number")
																			.textbox(
																					'setValue',
																					"");
																	$("#add_name")
																			.textbox(
																					'setValue',
																					"");
																	$("#add_sex")
																			.textbox(
																					'setValue',
																					"男");
																	$("#add_birthday")
																			.textbox(
																					'setValue',
																					"");
																	$("#add_grade")
																			.textbox(
																					'setValue',
																					"");
																	$("#add_major")
																			.textbox(
																					'setValue',
																					"");
																	//$("#add_clazzId").textbox('setValue', "");
																	$(
																			"#add_headteacher")
																			.textbox(
																					'setValue',
																					"");

																	//重新刷新页面数据
																	$(
																			'#dataList')
																			.datagrid(
																					"options").queryParams = {
																		clazzid : clazzid
																	};
																	$(
																			'#dataList')
																			.datagrid(
																					"reload");
																	setTimeout(
																			function() {
																				$(
																						"#clazzList")
																						.combobox(
																								'setValue',
																								clazzid);
																			},
																			100);

																} else {
																	$.messager
																			.alert(
																					"消息提醒",
																					"添加失败!",
																					"warning");
																	return;
																}
															}
														});
											}
										}
									},
									{
										text : '重置',
										plain : true,
										iconCls : 'icon-reload',
										handler : function() {
// 											$("#add_sn")
// 													.textbox('setValue', "");
											$("#add_number").textbox(
													'setValue', "");
											$("#add_name").textbox('setValue',
													"");
											$("#add_birthday").textbox(
													'setValue', "");
											$("#add_grade").textbox('setValue',
													"");
											$("#add_major").textbox('setValue',
													"");
											$("#add_clazzId").textbox(
													'setValue', "");
											$("#add_headteacher").textbox(
													'setValue', "");
											//重新加载年级
// 											$("#add_gradeList").combobox(
// 													"clear");
// 											$("#add_gradeList").combobox(
// 													"reload");
										}
									}, ]
						});

		//设置编辑学生窗口
		$("#editDialog")
				.dialog(
						{
							title : "修改学生信息",
							width : 650,
							height : 460,
							iconCls : "icon-edit",
							modal : true,
							collapsible : false,
							minimizable : false,
							maximizable : false,
							draggable : true,
							closed : true,
							buttons : [
									{
										text : '提交',
										plain : true,
										iconCls : 'icon-user_add',
										handler : function() {
											var validate = $("#editForm").form(
													"validate");
											var clazzid = $("#edit_clazzList")
													.combobox("getValue");
											if (!validate) {
												$.messager
														.alert("消息提醒",
																"请检查你输入的数据!",
																"warning");
												return;
											} else {
												$
														.ajax({
															type : "post",
															url : "StudentServlet?method=EditStudent&t="
																	+ new Date()
																			.getTime(),
															data : $(
																	"#editForm")
																	.serialize(),
															success : function(
																	msg) {
																if (msg == "success") {
																	$.messager
																			.alert(
																					"消息提醒",
																					"更新成功!",
																					"info");
																	//关闭窗口
																	$(
																			"#editDialog")
																			.dialog(
																					"close");
																	//刷新表格
																	$(
																			'#dataList')
																			.datagrid(
																					"options").queryParams = {
																		clazzid : clazzid
																	};
																	$(
																			"#dataList")
																			.datagrid(
																					"reload");
																	$(
																			"#dataList")
																			.datagrid(
																					"uncheckAll");

																	setTimeout(
																			function() {
																				$(
																						"#clazzList")
																						.combobox(
																								'setValue',
																								clazzid);
																			},
																			100);

																} else {
																	$.messager
																			.alert(
																					"消息提醒",
																					"更新失败!",
																					"warning");
																	return;
																}
															}
														});
											}
										}
									},
									{
										text : '重置',
										plain : true,
										iconCls : 'icon-reload',
										handler : function() {
											//清空表单 
// 											$("#edit_sn").textbox('setValue',
// 													"");
											$("#edit_name").textbox('setValue',
													"");
											$("#edit_sex").textbox('setValue',
													"男");
											$("#edit_birthday").textbox(
													'setValue', "");
											$("#edit_grade").textbox(
													'setValue', "");
											$("#edit_major").textbox(
													'setValue', "");
											$("#edit_headteacher").textbox(
													'setValue', "");
// 											$("#edit_gradeList").combobox(
// 													"clear");
// 											$("#edit_gradeList").combobox(
// 													"reload");
										}
									} ],
							onBeforeOpen : function() {
								var selectRow = $("#dataList").datagrid(
										"getSelected");
								//设置值
								//$("#edit_sn").textbox('setValue', selectRow.sn);
								$("#edit_name").textbox('setValue',
										selectRow.name);
								$("#edit_sex").textbox('setValue',
										selectRow.sex);
								$("#edit_birthday").textbox('setValue',
										selectRow.birthday);
								$("#edit_grade").textbox('setValue',
										selectRow.grade);
								$("#edit_major").textbox('setValue',
										selectRow.major);
								//$("#edit_clazzId").textbox('setValue',  selectRow.clazzId);
								$("#edit_headteacher").textbox('setValue',
										selectRow.headteacher);
								$("#edit-id").val(selectRow.id);

								var clazzid = selectRow.clazzId;
								setTimeout(function() {
									$("#edit_clazzList").combobox('setValue',
											clazzid);
								}, 100);

							}
						});
		//搜索按钮监听事件
		$("#search-btn").click(
				function() {
					$('#dataList')
							.datagrid(
									'load',
									{//search_student_name
										studentName : $('#search_student_name')
												.val(),
										clazzid : $("#clazzList").combobox(
												'getValue') == '' ? 0 : $(
												"#clazzList").combobox(
												'getValue')
									});
				});
	});
</script>
</head>
<body>
	<!-- 学生列表 -->
	<table id="dataList" cellspacing="0" cellpadding="0">

	</table>
	<!-- 工具栏 -->
	<div id="toolbar">
		<c:if test="${userType == 1 || userType == 3}">
			<div style="float: left;">
				<a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
			</div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="float: left;">
			<a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
		</div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${userType == 1 || userType == 3}">
			<div style="float: left;">
				<a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">删除</a>
			</div>
		</c:if>
		<div style="float: left; margin-top: 4px;" class="datagrid-btn-separator">
			&nbsp;&nbsp;姓名：
			<input id="search_student_name" class="easyui-textbox" name="search_student_name" />
		</div>
		<div style="margin-left: 10px; margin-top: 4px;">
			班级：
			<input id="clazzList" class="easyui-textbox" name="clazz" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">搜索</a>
		</div>

	</div>

	<!-- 添加学生窗口 -->
	<div id="addDialog" style="padding: 10px">

		<form id="addForm" method="post" action="">
			<table cellpadding="8">
				<tr>
					<td>姓名:</td>
					<td>
						<input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" />
					</td>
				</tr>
	    		<tr>
	    			<td>密码:</td>
	    			<td>
	    				<input id="add_password"  class="easyui-textbox" style="width: 200px; height: 30px;" type="password" name="password" data-options="required:true, missingMessage:'请输入登录密码'" />
	    			</td>
	    		</tr>
					<td>性别:</td>
					<td>
						<select id="add_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex">
							<option value="男">男</option>
							<option value="女">女</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>出生日期:</td>
					<td>
						<input id="add_birthday" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="birthday" data-options="required:true, missingMessage:'格式为YYYY-MM-dd'" />
					</td>
				</tr>
				<tr>
					<td>年级:</td>
					<td>
						<input id="add_grade" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="grade" />
					</td>
				</tr>
				<tr>
					<td>专业:</td>
					<td>
						<input id="add_major" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="major" />
					</td>
				</tr>
				<tr>
					<td>班级:</td>
					<td>
						<input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" />
					</td>
				</tr>
				<tr>
					<td>班主任:</td>
					<td>
						<input id="add_headteacher" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="headteacher" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<!-- 修改学生窗口 -->
	<div id="editDialog" style="padding: 10px">


		<form id="editForm" method="post" action="">
			<input type="hidden" name="id" id="edit-id">
			<table cellpadding="8">
				<tr>
					<td>姓名:</td>
					<td>
						<input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'请填写姓名'" />
					</td>
				</tr>
				<tr>
					<td>性别:</td>
					<td>
						<select id="edit_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex">
							<option value="男">男</option>
							<option value="女">女</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>出生日期:</td>
					<td>
						<input id="edit_birthday" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="birthday" />
					</td>
				</tr>
				<tr>
					<td>年级:</td>
					<td>
						<input id="edit_grade" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="grade" />
					</td>
				</tr>
				<tr>
					<td>专业:</td>
					<td>
						<input id="edit_major" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="major" />
					</td>
				</tr>
				<tr>
					<td>班级:</td>
					<td>
						<input id="edit_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" />
					</td>
				</tr>
				<tr>
					<td>班主任:</td>
					<td>
						<input id="edit_headteacher" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="headteacher" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 提交表单处理iframe框架 -->
	<iframe id="photo_target" name="photo_target"></iframe>
</body>
</html>