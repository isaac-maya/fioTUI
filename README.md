<h1 align="center"> fioTUI </h1>
<p align="center">
        <img alt="fioTUI" title="fioTUI" src="https://d29fhpw069ctt2.cloudfront.net/icon/image/120784/preview.svg" width="300">
  </a>
</p>
<h2 align="center"> Terminal user interface wrapper for FIO </h2> 


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Why?](#why?)
- [Installation](#installation)
- [Features](#features)
- [Acknowledgments](#acknowledgments)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Why?

<p align="center">
  <img width="800" src="https://github.com/xivawi/fioTUI/blob/main/ez_oc.gif">
</p>

- FIO usage applies in many use cases, nonetheless its several configuration modes as well fine grain control workload modularity can turn to be cumbersome for some users.

- I consider FIO to be a very useful tool that can be easier to leverage by new users. If FIO workload options election can be simplified it would mean more users could use the software.

- This TUI wrapper aims to smoothen the learning curve for FIO, making it more accessible.

## Features
* Six different IO patterns
<p align="center">
  <img width="800" src="https://github.com/xivawi/fioTUI/blob/main/iotypes.png">
</p>

* Two modes of operation,

* ez mode allows fast and easy configuration of workloads.
<p align="center">
  <img width="800" src="https://github.com/xivawi/fioTUI/blob/main/ez.gif">
</p>

* oc mode enables fine grain control over workloads.
<p align="center">
  <img width="800" src="https://github.com/xivawi/fioTUI/blob/main/oc.gif">
</p>

* Workloads run on block devices (/mnt/EXAMPLE)
<p align="center">
  <img width="800" src="https://github.com/xivawi/fioTUI/blob/main/location.png">
</p>

* Byobu permits multiple workload running and monitoring.
  
## Installation

**APT based systems**
- `apt install fio`
- `apt install newt || apt install whiptail`

**RPM based systems**
- `dnf install fio`
- `dnf install newt || dnf install whiptail`

## Acknowledgments

<h3 align="center"> https://github.com/axboe/fio
<h3 align="center"> https://pagure.io/newt
