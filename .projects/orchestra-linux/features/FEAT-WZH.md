---
id: FEAT-WZH
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Voice STT via Vosk + Whisper.cpp
type: feature
---

# Voice STT via Vosk + Whisper.cpp

Implement services.voice STT tools on Linux. Primary offline: Vosk (libvosk) — load model from ~/.local/share/orchestra/models/vosk-model-*, open PipeWire microphone stream via GStreamer (pulsesrc → audioconvert → audioresample → appsink), feed PCM chunks to VoskRecognizer, return transcription text. Streaming: emit partial results via STT streaming protocol. Secondary: Whisper.cpp CLI — record audio to temp WAV via GStreamer, invoke whisper-cli, parse output. Provider STT: OpenAI Whisper API, Google Cloud Speech, Deepgram via HTTP. Calls stt_listen (streaming), stt_transcribe_file, stt_list_models, voice_config tools.