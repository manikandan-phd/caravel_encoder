# Caravel Multi encoder

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)



This work is an integrated multi purpose encoder design which can simultaneously get two 32-bit data and key of 32-bit size for generating 32-bit encoded data. Those two 32-bit data may belong to the same process in case of data encryption(64-bit parallel encryption can be done) or it can be from different processes in case of signal processing applications to establish authentication.

The encoder design is integrated with caravel through LA. Inputs for the encoder can be fed from caravel management area through LA and output can also be read from LA.

Testbench and sample firmware to evaluate the multi encoder can be found in /caravel_encoder/tree/main/verilog/dv/la_test1. 


Refer to [README](docs/source/index.rst) for the environmental setup, project compilation and validation. 



**ACKNOWLEDGEMENT**

[1] Mr. Matthew Venn, Technology Communicator, Zero to ASIC course for the overwhelming support and guidance                                                                                                                                                                                     
[2] Efabless team members for their continual support in slack                                                                                                        
[3] Prof. Muthaiah R, SASTRA Deemed to be University, Thanjavur, Tamilnadu, India 
