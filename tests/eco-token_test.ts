import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Allows contract owner to add verifiers",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const verifier = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "eco-token",
        "add-verifier",
        [types.principal(verifier.address)],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result, '(ok true)');
  },
});

Clarinet.test({
  name: "Allows users to register projects",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const user = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "eco-token",
        "register-project",
        [
          types.ascii("Test Project"),
          types.ascii("A test environmental project")
        ],
        user.address
      )
    ]);
    assertEquals(block.receipts[0].result, '(ok u1)');
  },
});

Clarinet.test({
  name: "Allows verifiers to verify projects and add credits",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const verifier = accounts.get("wallet_1")!;
    const user = accounts.get("wallet_2")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "eco-token",
        "add-verifier",
        [types.principal(verifier.address)],
        deployer.address
      ),
      Tx.contractCall(
        "eco-token", 
        "register-project",
        [
          types.ascii("Test Project"),
          types.ascii("A test environmental project")
        ],
        user.address
      ),
      Tx.contractCall(
        "eco-token",
        "verify-project",
        [types.uint(1)],
        verifier.address
      ),
      Tx.contractCall(
        "eco-token",
        "add-carbon-credits",
        [types.uint(1), types.uint(100)],
        verifier.address
      )
    ]);
    assertEquals(block.receipts[3].result, '(ok true)');
  },
});
