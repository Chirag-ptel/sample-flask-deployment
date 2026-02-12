# app/routes.py

from app import app
from flask import request

items = []

@app.route('/')
def hello():
    html = '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Flask Items API</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; }
            pre { background: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }
            h2 { color: #333; }
            .endpoint { margin: 20px 0; padding: 15px; border-left: 4px solid #007cba; background: #f9f9f9; }
        </style>
    </head>
    <body>
        <h1>🛒 Items API Documentation</h1>
        
        <div class="endpoint">
            <h2>📋 GET /items</h2>
            <p>Get all items</p>
            <pre>curl http://localhost:port/items</pre>
            <p><strong>Response:</strong> {"items": [{"name": "Laptop", "price": 1200}, ...]}</p>
        </div>
        
        <div class="endpoint">
            <h2>🔍 GET /items/&lt;int:item_id&gt;</h2>
            <p>Get specific item by ID</p>
            <pre>curl http://localhost:port/items/0</pre>
            <p><strong>Response:</strong> {"item": {"name": "Laptop", "price": 1200}}</p>
            <p><strong>Error (404):</strong> {"error": "Item not found"}</p>
        </div>
        
        <div class="endpoint">
            <h2>➕ POST /items</h2>
            <p>Add new item</p>
            <pre>curl -X POST http://localhost:port/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 1200}'</pre>
            <p><strong>Response:</strong> {"message": "Item added successfully"} (201)</p>
        </div>
        
        <h3>📝 Sample POST Payloads:</h3>
        <pre>{
  "name": "Laptop",
  "price": 1200,
  "category": "Electronics"
}
{
  "name": "Book",
  "price": 25
}</pre>
    </body>
    </html>
    '''
    return html

@app.route('/items', methods=['GET'])
def get_items():
    return {'items': items}

@app.route('/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    if item_id < len(items):
        return {'item': items[item_id]}
    else:
        return {'error': 'Item not found'}, 404

@app.route('/items', methods=['POST'])
def add_item():
    item = request.get_json()
    items.append(item)
    return {'message': 'Item added successfully'}, 201
