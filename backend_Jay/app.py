from flask import Flask, request, Response, stream_with_context, jsonify
from voice_agent import process_final_summary, run_ollama_stream

app = Flask(__name__)

@app.route('/chat', methods=['POST'])

def chat():
    """
    Streams the AI doctor's response in real-time.
    """

    data = request.get_json()
    if not data or 'core_prompt' not in data or 'transcript' not in data:
        return jsonify({'error': 'Missing "core_prompt" or "transcript" in the request'}), 400

    core_prompt = data['core_prompt']
    transcript = data['transcript']

    composite_prompt = (
        f"{core_prompt}\n\n"
        f"Here's the transcript so far:\n{transcript}\n\n"
        "Doctor, please continue the conversation. BE SUPER SHORT AND CONCISE BY OUTPUTTING ONLY ONE LINE. Your response will be directly transmitted to the patient, so DO NOT summarize or explain the response itself and DO NOT give away that you are an AI model."
    )

    def generate():
        counter = 0
        for chunk in run_ollama_stream(composite_prompt):
            yield chunk + "\n"
    return Response(stream_with_context(generate()), content_type="text/plain")

@app.route('/final_summary', methods=['POST'])
def final_summary():
    """
    Expects JSON with:
      - core_prompt: (string) The early core prompt for the conversation.
      - transcript: (string) The full transcript of the conversation.
      
    Returns a JSON object with the final patient note (summary, differential, and assessment & plan).
    """
    data = request.get_json()
    if not data or 'core_prompt' not in data or 'transcript' not in data:
        return jsonify({'error': 'Missing "core_prompt" or "transcript" in the request'}), 400

    core_prompt = data['core_prompt']
    transcript = data['transcript']

    response = process_final_summary(core_prompt, transcript)
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)