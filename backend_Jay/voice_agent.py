import subprocess
import json

def run_ollama(prompt):
    """
    Runs the DeepSeek model via Ollama using the given prompt.
    Returns the output text, or an error message if the call fails.
    """
    command = ["ollama", "run", "deepseek-r1:8b", "--input", prompt]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        output_text = result.stdout.strip()
        return output_text
    except subprocess.CalledProcessError as e:
        return f"Error invoking DeepSeek: {e}"

def process_chat(core_prompt, transcript):
    """
    Builds a composite prompt for the current conversation turn.
    """
    composite_prompt = (
        f"{core_prompt}\n\n"
        f"Here's the transcript so far:\n{transcript}\n\n"
        "Doctor, please continue the conversation. BE SUPER SHORT AND CONCISE."
    )

    # Debug: Print the composite prompt being sent to DeepSeek
    print("=== Sending composite prompt to DeepSeek ===")
    print(composite_prompt)
    print("=============================================")

    output_text = run_ollama(composite_prompt)
    print("=== DeepSeek output is as follows ===")
    print(output_text)
    print("=============================================")
    response = {
        "response": output_text,
        "transcript_update": f"Doctor said: {output_text}"
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
        "final_note": output_text
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
