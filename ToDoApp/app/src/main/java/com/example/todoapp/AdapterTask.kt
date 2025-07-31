package com.example.todoapp

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.todoapp.databinding.ActivityAdapterTaskBinding

import com.example.todoapp.model.Task

class TaskAdapter(private val onDeleteClick: (Task) -> Unit) :
    RecyclerView.Adapter<TaskAdapter.TaskViewHolder>() {

    private var taskList = listOf<Task>()

    fun submitList(list: List<Task>) {
        taskList = list
        notifyDataSetChanged()
    }

    inner class TaskViewHolder(val binding: ActivityAdapterTaskBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TaskViewHolder {
        val binding = ActivityAdapterTaskBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return TaskViewHolder(binding)
    }

    override fun onBindViewHolder(holder: TaskViewHolder, position: Int) {
        val task = taskList[position]
        holder.binding.maintitle.text = task.description
        holder.binding.tvTitle.text = task.title
        holder.binding.btnDelete.setOnClickListener { onDeleteClick(task) }
    }

    override fun getItemCount() = taskList.size
}
