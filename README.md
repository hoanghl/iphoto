# iPhoto

## 1. Introduction

_iPhoto_ is a full-stack app leveraging image or video display (in front-end) and storing (in back-end).

### 1.1. System architecture

![Basic blocks](pictures/iphoto-general-block.png "EvilTrans basic blocks")

#### a. Client

An app to show images/videos. In stage 2, smartphone app and other devices participating the network are used to store distributed data, which is inspired from Pipernet.

#### b. Web server

#### c. Feature Matcher

#### d. InfoDB

InfoDB uses PostgreSQL database to store metadata about resources.

#### e. FileDB

### 1.2. System sequence diagram

![Sequence diagram](pictures/iphoto-sequence-diagram.png)

## 2. Client

**Flutter** is used to develop smartphone application.
Please visit this branch [Client](https://github.com/hoanghl/iphoto/tree/fe) for more information.

## 3. Server

Please visit this branch [Server](https://github.com/hoanghl/iphoto/tree/be) for more information.
