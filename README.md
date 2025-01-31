# EcoToken
A blockchain-based system for tracking and incentivizing environmental initiatives.

## Overview
EcoToken allows organizations to:
- Register environmental projects
- Track carbon offset credits
- Award tokens for verified environmental actions
- Trade environmental credits
- Burn tokens to demonstrate commitment to environmental causes

## Contract Functions
- Register new environmental projects
- Submit environmental impact data
- Verify and approve environmental actions
- Mint and transfer eco tokens
- Burn tokens with tracking mechanism
- Query project and token data

## Token Burn Mechanism
The contract now includes a token burn feature that allows token holders to permanently remove tokens from circulation. This demonstrates long-term commitment to environmental causes and helps maintain token value. The total amount of burned tokens is tracked and queryable.

## Setup and Testing
1. Install Clarinet
2. Run `clarinet test` to execute test suite
3. Deploy using `clarinet deploy`
