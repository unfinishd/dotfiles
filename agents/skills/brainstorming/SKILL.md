---
name: brainstorming
description: "Use before creative work: creating features, building components, adding functionality, or modifying behavior. Explore user intent, requirements, and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- Once you have a rough sense of the idea, search available documentation via MCP for relevant material to reference.
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why
- When you are working on schemas or interfaces, don't feed decisions one-by-one. Propose the full schema, and highlight all the decisions/trade-offs in one go.

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, key interfaces and data structures, data flow, error handling, testing
    - Very important: Show the key interfaces and data structures explicitly/prominently
    - Very important: Show core algorithms explicitly/prominently
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use a planning workflow to create a detailed implementation plan

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify if something doesn't make sense
- **Interfaces and data structures form the core of the design** - Always show the key interfaces and data structures explicitly/prominently
- **DDD** - Follow Domain Driven Design (DDD) patterns when possible. What are the key domain models, services, and repositories?
