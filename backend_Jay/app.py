from flask import Flask, request, jsonify
from voice_agent import process_chat, process_final_summary

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    """
    Expects JSON with:
      - core_prompt: (string) The early core prompt for the conversation.
      - transcript: (string) The transcript so far.
    """
    data = request.get_json()
    if not data or 'core_prompt' not in data or 'transcript' not in data:
        return jsonify({'error': 'Missing "core_prompt" or "transcript" in the request'}), 400

    core_prompt = data['core_prompt']
    transcript = data['transcript']

    # Debug: Print received transcript
    print("=== /chat endpoint received transcript ===")
    print(transcript)
    print("===========================================")

    response = process_chat(core_prompt, transcript)
    return jsonify(response)

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
