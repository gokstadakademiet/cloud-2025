from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os
import pymysql

# Replace MySQL-python (MySQLdb) with PyMySQL
pymysql.install_as_MySQLdb()

app = Flask(__name__)
# Update database URL to use pymysql
# Format: mysql+pymysql://username:password@host:port/database_name
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'mysql+pymysql://user:password@localhost/dbname')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.String(200), nullable=False)
    completed = db.Column(db.Boolean, default=False)

@app.route('/todos', methods=['GET'])
def get_todos():
    todos = Todo.query.all()
    return jsonify([{
        'id': todo.id,
        'task': todo.task,
        'completed': todo.completed
    } for todo in todos])

@app.route('/todos', methods=['POST'])
def add_todo():
    if not request.json or 'task' not in request.json:
        return jsonify({'error': 'Task is required'}), 400
    
    new_todo = Todo(task=request.json['task'])
    db.session.add(new_todo)
    db.session.commit()
    
    return jsonify({
        'id': new_todo.id,
        'task': new_todo.task,
        'completed': new_todo.completed
    }), 201

if __name__ == '__main__':
    app.run(debug=True)