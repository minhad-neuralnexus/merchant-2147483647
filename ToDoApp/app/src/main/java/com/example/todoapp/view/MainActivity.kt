package com.example.todoapp.view

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.todoapp.TaskAdapter
import com.example.todoapp.databinding.ActivityMainBinding
import com.example.todoapp.model.Task
import com.example.todoapp.viewmodel.TaskViewModel

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var taskViewModel: TaskViewModel
    private lateinit var adapter: TaskAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        taskViewModel = ViewModelProvider(this)[TaskViewModel::class.java]

        adapter = TaskAdapter { task -> taskViewModel.delete(task) }

        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        binding.recyclerView.adapter = adapter

        taskViewModel.allTasks.observe(this) { tasks ->
            adapter.submitList(tasks)
        }

        binding.btnAdd.setOnClickListener {
            val  eTitle =  binding.eTitle.text.toString()
            val taskText = binding.etTask.text.toString()
            if (taskText.isNotEmpty() && eTitle.isNotEmpty()) {
            val task = Task(title = eTitle, description = taskText)
            taskViewModel.insert(task)


                taskViewModel.insert(task)
                binding.etTask.text.clear()
                binding.eTitle.text.clear()
            }
        }
    }
}
