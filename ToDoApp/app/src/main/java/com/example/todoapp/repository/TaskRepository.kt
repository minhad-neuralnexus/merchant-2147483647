package com.example.todoapp.repository

import androidx.lifecycle.LiveData
import com.example.todoapp.model.Task
import com.example.todoapp.model.TaskDao

class TaskRepository(private val taskDao: TaskDao) {

    val allTasks: LiveData<List<Task>> = taskDao.getAllTasks()


    suspend fun insert(task: Task) = taskDao.insert(task)

    suspend fun delete(task: Task) = taskDao.delete(task)

}