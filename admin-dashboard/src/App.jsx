import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, CheckSquare, Trash2, Edit } from 'lucide-react';

const API_BASE_URL = 'http://localhost:8000'; // Update with Render URL later

const App = () => {
  const [tasks, setTasks] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // In a real app, we'd need admin auth. This is a bonus demo.
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      // Mocking admin access or using specific admin endpoints if implemented
      // For now, we'll assume the API allows fetching all if admin
      // const tasksRes = await axios.get(`${API_BASE_URL}/admin/tasks`);
      // setTasks(tasksRes.data);
      setLoading(false);
    } catch (error) {
      console.error("Error fetching data", error);
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: '40px', fontFamily: 'system-ui' }}>
      <header style={{ marginBottom: '40px' }}>
        <h1 style={{ color: '#673AB7' }}>Admin Dashboard</h1>
        <p>Manage users and tasks across the organization</p>
      </header>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '24px' }}>
        <div style={{ padding: '24px', borderRadius: '16px', backgroundColor: '#f3e5f5', border: '1px solid #e1bee7' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '16px' }}>
            <Users size={32} color="#673AB7" />
            <h2 style={{ margin: 0 }}>Users</h2>
          </div>
          <p style={{ fontSize: '24px', fontWeight: 'bold' }}>{users.length} Active Users</p>
        </div>

        <div style={{ padding: '24px', borderRadius: '16px', backgroundColor: '#e1f5fe', border: '1px solid #b3e5fc' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '16px' }}>
            <CheckSquare size={32} color="#03A9F4" />
            <h2 style={{ margin: 0 }}>Tasks</h2>
          </div>
          <p style={{ fontSize: '24px', fontWeight: 'bold' }}>{tasks.length} Total Tasks</p>
        </div>
      </div>

      <section style={{ marginTop: '48px' }}>
        <h2>Recent Tasks</h2>
        {loading ? <p>Loading...</p> : (
          <table style={{ width: '100%', borderCollapse: 'collapse', marginTop: '16px' }}>
            <thead>
              <tr style={{ textAlign: 'left', borderBottom: '2px solid #eee' }}>
                <th style={{ padding: '12px' }}>Title</th>
                <th style={{ padding: '12px' }}>Status</th>
                <th style={{ padding: '12px' }}>Priority</th>
                <th style={{ padding: '12px' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {tasks.map(task => (
                <tr key={task.id} style={{ borderBottom: '1px solid #eee' }}>
                  <td style={{ padding: '12px' }}>{task.title}</td>
                  <td style={{ padding: '12px' }}>{task.status}</td>
                  <td style={{ padding: '12px' }}>{task.priority}</td>
                  <td style={{ padding: '12px' }}>
                    <button style={{ marginRight: '8px' }}><Edit size={16} /></button>
                    <button style={{ color: 'red' }}><Trash2 size={16} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
};

export default App;
