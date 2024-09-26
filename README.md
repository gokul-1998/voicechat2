# voicechat2
A fast, fully local AI Voicechat using WebSockets
- WebSocket server, allows for simple remote access
- Default web UI w/ VAD using [ricky0123/vad](https://github.com/ricky0123/vad), Opus support using [symblai/opus-encdec](https://github.com/symblai/opus-encdec)
- Modular/swappable SRT, LLM, TTS servers
  - SRT: [whisper.cpp](https://github.com/ggerganov/whisper.cpp), [faster-whisper](https://github.com/SYSTRAN/faster-whisper), or [HF Transformers whisper](https://huggingface.co/docs/transformers/en/model_doc/whisper)
  - LLM: [llama.cpp](https://github.com/ggerganov/llama.cpp) or any OpenAI API compatible server
  - TTS: [coqui-tts](https://github.com/idiap/coqui-ai-TTS), [StyleTTS2](https://github.com/yl4579/StyleTTS2), [Piper](https://github.com/rhasspy/piper), [MeloTTS](https://github.com/myshell-ai/MeloTTS)

[voicechat2 demo video](https://github.com/user-attachments/assets/498ce979-18b6-4225-b0da-01b6910e2bd7)

<sup>*Unmute to hear the audio*</sup>

On an 7900-class AMD RDNA3 card, voice-to-voice latency is in the 1 second range:
- [distil-whisper/distil-large-v2](https://huggingface.co/distil-whisper/distil-large-v2)
- [bartowski/Meta-Llama-3.1-8B-Instruct-GGUF](https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF) (Q4_K_M)
- tts_models/en/vctk/vits (Coqui TTS default VITS models)

On a 4090, using [Faster Whisper](https://github.com/SYSTRAN/faster-whisper) with [faster-distil-whisper-large-v2](https://huggingface.co/Systran/faster-distil-whisper-large-v2) we can cut the latency down to as low as 300ms:  

[voicechat2 demo](https://github.com/user-attachments/assets/5b8a3805-0116-4f7b-920d-231a2dbfb481)

You can of course run any model or swap out any of the SRT, LLM, TTS components as you like. For example, you can run [whisper.cpp](https://github.com/ggerganov/whisper.cpp) for SRT, or we have a [StyleTTS2](https://github.com/yl4579/StyleTTS2) server in the test folder for an alternative TTS. For a bit more about this project, see my [Hackster.io writeup](https://www.hackster.io/lhl/voicechat2-local-ai-voice-chat-4c48f2).

# Install
These installation instructions are for Ubuntu LTS and assume you've [setup your ROCm](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/tutorial/quick-start.html) or [CUDA](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/) already.

I recommend you use [conda](https://docs.conda.io/en/latest/) or (my preferred), [mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html) for environment management. It will make your life easier.

## System Prereqs
```
sudo apt update

# Not strictly required but the helpers we use
sudo apt install byobu curl wget

# Audio processing
sudo apt install espeak-ng ffmpeg libopus0 libopus-dev 
```

## Checkout code 
```
# Create env
mamba create -y -n voicechat2 python=3.11

# Setup
mamba activate voicechat2
git clone https://github.com/lhl/voicechat2
cd voicechat2
pip install -r requirements.txt
```

## llama.cpp
```
# Build llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
# AMD version
make GGML_HIPBLAS=1 -j 
# Nvidia version
make GGML_CUDA=1 -j 

# Grab your preferred GGUF model
wget https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf

# If you're going to go to the next instruction
cd ..
```

Some extra convenience scripts for launching:
```
run-voicechat2.sh - on your GPU machine, tries to launch all servers in separate byobu sessions; update the MODEL variables
remote-tunnel.sh - connect your GPU machine to a jump machine
local-tunnel.sh - connect to the GPU machine via a jump machine
```

# Other AI Voicechat Projects

## Speech To Speech
A project released after voicechat2 that uses a similar modular approach but is local device oriented
- https://github.com/eustlb/speech-to-speech
- No license?

## webrtc-ai-voice-chat
The demo shows a fair amount of latency (~10s) but this project isn't the closest to what we're doing (it uses WebRTC not websockets) from voicechat2 (HF Transformers, Ollama)
- https://github.com/lalanikarim/webrtc-ai-voice-chat
- Apache 2.0

## june
A console-based local client (HF Transformers, Ollama, Coqui TTS, PortAudio)
- https://github.com/mezbaul-h/june
- MIT

## GlaDOS
This is a very responsive console-based local-client app that also has VAD and interruption support, plus a really clever hook! (whisper.cpp, llama.cpp, piper, espeak)
- https://github.com/dnhkng/GlaDOS
- MIT

## local-talking-llm
Another console-based local client, more of a proof of concept but with w/ blog writeup.
- https://github.com/vndee/local-talking-llm
- https://blog.duy.dev/build-your-own-voice-assistant-and-run-it-locally/
- MIT

## BUD-E - natural_voice_assistant
Another console-based local client (FastConformer, HF Transformers, StyleTTS2, espeak)
- https://github.com/LAION-AI/natural_voice_assistant
- MIT

## LocalAIVoiceChat
KoljaB has a number of interesting projects around console-based local clients like [RealtimeSTT](https://github.com/KoljaB/RealtimeSTT), [RealtimeTTS](https://github.com/KoljaB/RealtimeTTS), [Linguflex](https://github.com/KoljaB/Linguflex), etc. (faster_whisper, llama.cpp, Coqui XTTS)
- https://github.com/KoljaB/LocalAIVoiceChat
- NC (Coqui Model License)

## rtvi-web-demo
This is *not* a local voicechat client, but it does have a neat WebRTC front-end, so might be worth poking around into (Vite/React, Tailwind, Radix)
- https://github.com/rtvi-ai/rtvi-web-demo
