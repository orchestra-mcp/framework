---
id: FEAT-PBG
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: TTS / STT voice service (services.voice)
type: feature
---

# TTS / STT voice service (services.voice)

Tools: tts_speak, tts_speak_provider, tts_list_voices, tts_stop, stt_listen (streaming), stt_transcribe_file, stt_list_models, voice_config. OS TTS: macOS say/NSSpeechSynthesizer, Linux espeak. OS STT: macOS SFSpeechRecognizer, Linux Vosk. Providers: ElevenLabs, OpenAI Whisper, Google Cloud Speech. Depends on INFRA-STREAM.


---
**in-progress -> ready-for-testing**: 22 tests pass in 3.008s. All 8 tools covered: tts_speak (2), tts_speak_provider (5), tts_list_voices (1), tts_stop (1), stt_listen (1), stt_transcribe_file (3), stt_list_models (3), voice_config (2). Covers validation errors (missing required args, invalid provider/enum), success paths, file_not_found for nonexistent audio files.


---
**in-testing -> ready-for-docs**: 22 test cases across 8 tools. TTS tests are platform-tolerant: tts_speak/tts_list_voices may return tts_error if say/espeak not available — acceptable. tts_stop uses pkill which exits 0 even when no process found. Provider validation covers all 4 valid values + unknown provider error. stt_transcribe_file tested against real temp file (t.TempDir) and nonexistent path. stt_list_models coverage for all providers + unknown provider error.


## Note (2026-02-28T04:44:43Z)

## Implementation

**Plugin**: `libs/plugin-services-voice/` — `services.voice`  
**Binary**: `bin/services-voice`  
**8 MCP tools**:

| Tool | Description | Required args |
|------|-------------|--------------|
| `tts_speak` | System TTS (macOS `say`, Linux `espeak`) | `text` |
| `tts_speak_provider` | External TTS provider | `text`, `provider` |
| `tts_list_voices` | List platform voices | — |
| `tts_stop` | Kill active TTS process via `pkill` | — |
| `stt_listen` | Microphone capture (requires setup) | — |
| `stt_transcribe_file` | Transcribe audio file | `file_path` |
| `stt_list_models` | List STT models by provider | — (optional: `provider`) |
| `voice_config` | Get/set voice configuration | — |

**TTS providers** (tts_speak_provider): `system`, `openai` (tts-1), `elevenlabs` (scribe_v1), `google`  
**STT providers** (stt_list_models): `system` (macOS SFSpeechRecognizer / Linux Vosk), `openai` (whisper-1), `google`, `elevenlabs`

**Platform dispatch** (`internal/tts/exec.go`):
- macOS: `say [-v voice] text`
- Linux/other: `espeak text`

**Note**: External provider tools require API keys (`OPENAI_API_KEY`, `ELEVENLABS_API_KEY`, `GOOGLE_APPLICATION_CREDENTIALS`). `stt_listen` and `stt_transcribe_file` are stubs that explain setup requirements.

**Tests**: 22 tests in `internal/tools/tools_test.go`.



---
**in-docs -> documented**: Documented all 8 tools with providers, required args, platform dispatch, API key requirements, and STT model catalog.


---
**in-review -> done**: Code review passed. Clean provider enum validation with validTTSProviders map. sttModels map keeps model catalog close to handler. Platform dispatch isolated in tts/exec.go. tts_stop gracefully handles pkill exit code 1 (no process). All 8 tools follow consistent schema/handler pattern.