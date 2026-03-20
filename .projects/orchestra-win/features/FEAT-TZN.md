---
id: FEAT-TZN
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Voice plugin — Windows.Media.Speech TTS + STT + provider fallback
type: feature
---

# Voice plugin — Windows.Media.Speech TTS + STT + provider fallback

Implement `Orchestra.Desktop/Services/VoiceService.cs` — text-to-speech and speech-to-text via Windows built-in APIs + cloud provider fallback.

**TTS — `Windows.Media.SpeechSynthesis.SpeechSynthesizer`:**
```csharp
var stream = await _synthesizer.SynthesizeTextToStreamAsync(text);
var player = new MediaPlayer();
player.Source = MediaSource.CreateFromStream(stream, stream.ContentType);
player.Play();
```
Fallback providers: ElevenLabs REST API, OpenAI TTS (`/v1/audio/speech`), Google Cloud TTS

**STT — `Windows.Media.SpeechRecognition.SpeechRecognizer`:**
```csharp
await _recognizer.CompileConstraintsAsync();
var result = await _recognizer.RecognizeAsync();  // continuous or one-shot
```
Fallback providers: OpenAI Whisper (`/v1/audio/transcriptions`), Google Cloud Speech, Deepgram

**`VoiceService` API (services.voice — 8 tools):**
- `tts_speak` — OS TTS or provider TTS
- `tts_speak_provider` — force specific provider (elevenlabs/openai/google)
- `tts_list_voices` — `SpeechSynthesizer.AllVoices` + provider voices
- `tts_stop` — cancel current playback (`MediaPlayer.Pause`)
- `stt_listen` — start listening, return transcript on silence
- `stt_transcribe_file` — transcribe audio file via Whisper
- `stt_list_models` — list available STT engines/models
- `voice_config` — get/set current TTS voice, STT engine, language

**Mic button:** floating `Button` in chat input → hold to record, release to transcribe + insert text

**Platform:** Desktop, Xbox, HoloLens (all support Windows.Media.Speech)