import subprocess
import json

def parse_output_text(s): return s.split('</think>', 1)[-1].split('Doctor:', 1)[-1].strip()

def run_ollama(prompt):
    """
    Runs the DeepSeek model via Ollama using the given prompt.
    Returns the output text, or an error message if the call fails.
    """
    command = ["ollama", "run", "deepseek-r1:8b", prompt]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        output_text = result.stdout.strip()
        return output_text
    except subprocess.CalledProcessError as e:
        return f"Error invoking DeepSeek: {e}"

def run_ollama_stream(prompt):
    """
    Runs the DeepSeek model via Ollama using real-time streaming.
    """
    command = ["ollama", "run", "deepseek-r1:8b", prompt]

    with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True) as process:
        current_chunk = ""
        thinking = False
        current_word = ""  # Reset word buffer
        while True:
            char = process.stdout.read(1)  # Read one character at a time
            if not char:
                break  # Stop if there's no more output
            
            if char.isspace():  # Space means the word is complete
                word = current_word.strip()  # Capture the full word
                
                if word:
                    # omit thinking
                    if "<think>" in word:
                        thinking = True
                        current_word = ""
                    elif "</think>" in word:
                        thinking = False
                        current_word = ""
                    elif not thinking:  # Only yield actual responses
                        yield parse_output_text(word) + " "  # Maintain spacing
                        current_word = ""
            
            else:
                current_word += char  # Keep building the word

        process.stdout.close()
        process.wait()

def process_chat(core_prompt, transcript):
    """
    Builds a composite prompt for the current conversation turn.
    """
    composite_prompt = (
        f"{core_prompt}\n\n"
        f"Here's the transcript so far:\n{transcript}\n\n"
        "Doctor, please continue the conversation. BE SUPER SHORT AND CONCISE BY OUTPUTTING ONLY ONE LINE. Your response will be directly transmitted to the patient, so DO NOT summarize or explain the response itself and DO NOT give away that you are an AI model."
    )

    # Debug: Print the composite prompt being sent to DeepSeek
    print("=== Sending composite prompt to DeepSeek ===")
    print(composite_prompt)
    print("=============================================")

    output_text = run_ollama(composite_prompt)
    parsed_output = parse_output_text(output_text)
    print("=== DeepSeek output is as follows ===")
    print(parsed_output)
    print("=============================================")
    response = {
        "response": parsed_output,
        "transcript_update": f"Doctor said: {parsed_output}"
    }
    return response

def process_final_summary(core_prompt, transcript):
    """
    Builds a composite prompt that includes the core prompt and the full transcript,
    and then asks for a final patient note. The note should include a summary of the history,
    differential diagnosis, and an assessment & plan.
    
    Returns a dictionary containing:
      - final_note: The final patient note.
    """
    composite_prompt = (
        f"{core_prompt}\n\n"
        f"FULL TRANSCRIPT:\n{transcript}\n\n"
        "Please provide a final patient note that includes a summary of the history, "
        "differential diagnosis, and an assessment & plan."
    )
    output_text = run_ollama(composite_prompt)
    response = {
        "final_note": parse_output_text(output_text)
    }
    return response

if __name__ == '__main__':
    # Quick tests when running this module directly.
    test_core = (
        "You are a physician seeing a patient. Your goal is to be empathetic and figure out the "
        "differential diagnosis, as well as the assessment and plan. You may continue the conversation or "
        "start wrapping things up, as you see fit. You need to collect enough information to understand the situation "
        "and make the patient feel heard."
    )
    test_transcript = (
        "Doctor said: What brings you in today?\n"
        "Patient said: I'm feeling nauseous.\n"
        "Doctor said: I'm sorry to hear that. How long have you been feeling this way?"
    )
    print("Chat Test Output:")
    print(json.dumps(process_chat(test_core, test_transcript), indent=2))
    print("\nFinal Summary Test Output:")
    print(json.dumps(process_final_summary(test_core, test_transcript), indent=2))