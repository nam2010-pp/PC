from flask import Flask, redirect

app = Flask(__name__)

@app.route('/')
def home():
    # Redirect đến noVNC (địa chỉ trong Codespaces)
    return redirect("http://127.0.0.1:6080", code=302)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
