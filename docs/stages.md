# Stage 1: Basic features

## 1. Functional features

### a. Front-end

- App fetches image/video from server
-
- [Done] An app that can can list images/videos in specified paths in smartphone
- App can select resources to upload
- App can fetch videos' thumbnail and image
- If user wants to play video, show video player

### b. Back-end

- [Done] Back-end allows client to list out available resource and download them
- Back-end can receive resources uploaded by front-end

## 2. Details

# Stage 2: Security enhancement

## 1. Functional features

### a. Front-end

- App can encrypt data right after it appears in specified directories
- App can send/receive encrypted resources

### b. Back-end

- Back-end can send/receive resources
- Back-end can store encrypted files in FileDB

## 2. Details

# Stage 3: Further enhancement

## 1. Functional features

### a. Front-end

- App can send large file by chunks

### b. Back-end

- Back-end can extract embedding
- Back-end can send/receive large resources by chunk
- FileDB follows distributed fashion as Pipernet.
- Backend uses _redist_ to store list of retrieved resource IDs to avoid retrieving frequently.

## 2. Details
