import websocket
import os
from dotenv import load_dotenv

load_dotenv()

TOKEN = os.getenv('FINNHUB_KEY')

tickers = ["AAPL","AMZN","BINANCE:BTCUSDT","IC MARKETS:1"]

def lambda_handler(event, context):
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(f"wss://ws.finnhub.io?token={TOKEN}",
                            on_message = on_message,
                            on_error = on_error,
                            on_close = on_close)
    ws.on_open = on_open
    ws.run_forever()

def on_message(ws, message):
    print(message)

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    for ticker in tickers:
        ws.send(f'{{"type":"subscribe","symbol":"{ticker}"}}')

lambda_handler({},{})