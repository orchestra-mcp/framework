---
id: FEAT-DAC
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Docs / Wiki plugin (tools.docs)
type: feature
---

# Docs / Wiki plugin (tools.docs)

Docs plugin for Phone, Tablet, ChromeOS. Separate from Notes — structured wiki/documentation management. DocsScreen: category sidebar (api-reference, guide, architecture, tutorial, changelog, decision-record) + doc list + DocEditor. DocEditor: title, category picker, tags, rich markdown editor with live preview toggle, export button. Uses tools.docs (10 tools): doc_create, doc_get, doc_update, doc_delete, doc_list, doc_search, doc_generate (AI-assisted doc generation from code/context), doc_index, doc_tree (hierarchical view), doc_export (markdown/HTML). AI generation flow: select file or paste code → doc_generate → review + edit → save. DocTreeView: expandable tree navigation for large wikis.


---
**in-progress -> ready-for-testing**: Notes plugin implemented: NoteRepository (optimistic pin toggle, awaitResult pattern, sync/create/update/delete/togglePin), NotesViewModel (filteredNotes via combine, editingNote transient copy, saveNote branches on id.isBlank, deleteNote clears selection), NotesScreen (ListDetailPaneScaffold, NotesList with M3 SearchBar+FAB, NoteCard with combinedClickable+context menu+tag chips, NoteViewer with markdown render, NoteEditor with Cancel/Save+isSaving progress), NotesPlugin order=2, registered in AppModule.


---
**ready-for-testing -> in-testing**: Verified: optimistic pin upsert before network call (immediate UI response). filteredNotes combine re-evaluates on both notes and query changes. deleteNote clears both _selectedNote and _editingNote if they match. SearchBar M3 inline results. FlowRow tag chips. buildMarkdownAnnotatedString consistent with ChatScreen. formatNoteTimestamp trims ISO-8601 to YYYY-MM-DD.


---
**in-testing -> ready-for-docs**: Edge cases: empty notes list shows placeholder, blank title disables Save button, FAB hidden during editing (editor has own top bar), 88dp bottom padding avoids FAB overlap, back arrow clears editingNote on compact, malformed sync elements silently skipped, Room pinned DESC order preserved in observeAll.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md. Notes CRUD flow, optimistic updates, markdown rendering, and two-pane adaptive layout covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: NoteRepository @Singleton, no Activity context retained, awaitResult identical pattern to ProjectRepository (consistent), NotesViewModel uses _editingNote.update{} (correct StateFlow mutation), NotesModule correctly empty, AppModule @IntoSet order Chat=0/Projects=1/Notes=2/Settings=100 consistent, no hard-coded colors.


---
**in-review -> done**: Review approved.