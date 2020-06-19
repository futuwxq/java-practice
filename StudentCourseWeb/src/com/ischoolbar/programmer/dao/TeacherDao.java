package com.ischoolbar.programmer.dao;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ischoolbar.programmer.model.Page;

import com.ischoolbar.programmer.model.Teacher;
import com.ischoolbar.programmer.util.StringUtil;

/**
 * 
 * @author future
 *教师表数据库操作
 */
public class TeacherDao extends BaseDao {
	public boolean addTeacher(Teacher teacher){
		String sql = "insert into teacher values(null,'"+teacher.getSn()+"','"+teacher.getName()+"'";
		sql += ",'" + teacher.getPassword() + "'," + teacher.getClazzId();
		sql += ",'" + teacher.getSex() + "','" + teacher.getMobile()+"') ";
		return update(sql);
	}
	public boolean editTeacher(Teacher teacher) {
		// TODO Auto-generated method stub
		String sql = "update teacher set name = '"+teacher.getName()+"'";
		sql += ",sex = '" + teacher.getSex() + "'";
		sql += ",mobile = '" + teacher.getMobile() + "'";
		sql += ",clazz_id = " + teacher.getClazzId();
		sql += " where id = " + teacher.getId();
		return update(sql);
	}
	public boolean deleteTeacher(String ids) {
		// TODO Auto-generated method stub
		String sql = "delete from teacher where id in("+ids+")";
		return update(sql);
	}
	public Teacher getTeacher(int id){
		String sql = "select * from teacher where id = " + id;
		Teacher teacher = null;
		ResultSet resultSet = query(sql);
		try {
			if(resultSet.next()){
				teacher = new Teacher();
				teacher.setId(resultSet.getInt("id"));
				teacher.setClazzId(resultSet.getInt("clazz_id"));
				teacher.setMobile(resultSet.getString("mobile"));
				teacher.setName(resultSet.getString("name"));
				teacher.setPassword(resultSet.getString("password"));
				teacher.setSex(resultSet.getString("sex"));
				teacher.setSn(resultSet.getString("sn"));
				return teacher;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return teacher;
	}
	public List<Teacher> getTeacherList(Teacher teacher,Page page){
		List<Teacher> ret = new ArrayList<Teacher>();
		String sql = "select * from teacher ";
		if(!StringUtil.isEmpty(teacher.getName())){
			sql += "and name like '%" + teacher.getName() + "%'";
		}
		if(teacher.getClazzId() != 0){
			sql += " and clazz_id = " + teacher.getClazzId();
		}
		if(teacher.getId() !=0 ){
			sql += " and id = " + teacher.getId();
		}
		sql += " limit " + page.getStart() + "," + page.getPageSize();
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				Teacher t = new Teacher();
				t.setId(resultSet.getInt("id"));
				t.setClazzId(resultSet.getInt("clazz_id"));
				t.setMobile(resultSet.getString("mobile"));
				t.setName(resultSet.getString("name"));
				t.setPassword(resultSet.getString("password"));
				t.setSex(resultSet.getString("sex"));
				t.setSn(resultSet.getString("sn"));
				ret.add(t);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
	public int getTeacherListTotal(Teacher teacher){
		int total = 0;
		String sql = "select count(*)as total from teacher ";
		if(!StringUtil.isEmpty(teacher.getName())){
			sql += "and name like '%" + teacher.getName() + "%'";
		}
		if(teacher.getClazzId() != 0){
			sql += " and clazz_id = " + teacher.getClazzId();
		}
		if(teacher.getId() !=0 ){
			sql += " and id = " + teacher.getId();
		}
		ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		try {
			while(resultSet.next()){
				total = resultSet.getInt("total");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return total;
	}
	public Teacher login(String name ,String password){
		String sql = "select * from teacher where name = '" + name + "' and password = '" + password + "'";
		ResultSet resultSet = query(sql);
		try {
			if(resultSet.next()){
				Teacher teacher = new Teacher();
				teacher.setId(resultSet.getInt("id"));
				teacher.setName(resultSet.getString("name"));
				teacher.setPassword(resultSet.getString("password"));
				teacher.setClazzId(resultSet.getInt("clazz_id"));
				teacher.setMobile(resultSet.getString("mobile"));
				teacher.setSex(resultSet.getString("sex"));
				teacher.setSn(resultSet.getString("sn"));
				return teacher;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	public boolean editPassword(Teacher teacher,String newPassword) {
		// TODO Auto-generated method stub
		String sql = "update teacher set password = '"+newPassword+"' where id = " + teacher.getId();
		return update(sql);
	}
}
