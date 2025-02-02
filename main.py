#uvicorn main:app
#uvicorn main:app --reload

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from decouple import config
from functions.openai_requests import convert_audio_to_text, get_chat_response
import openai
from functions.database import store_messages, reset_messages
from typing import Union


app = FastAPI()

origins = [
    "http://localhost:____"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],

)

@app.get("/health")
async def check_health():
    return {"Message": "healthy"}

@app.get("/reset")
async def reset_conversation():
    reset_messages()
    return {"Message": "reset"}


@app.get("/post-audio-get/")
async def get_audio():
    audio_input=open("voice.mp3", "rb")
    message_decoded = convert_audio_to_text(audio_input)
    if not message_decoded:
        return HTTPException(status_code=400, detail="no decode audio")
    
    chat_response=get_chat_response(message_decoded)
    
    
    store_messages(message_decoded, chat_response)
    
    print(chat_response)
    return "Done"
    
    
    print("hello")

