#!/usr/bin/env node
// Fetches PaperNFT claims via RPC and generates claims.json for the gallery

const CONTRACT = process.env.PAPER_NFT_ADDRESS || '0x3a9a92e0b35d8c6c85ced8b92b6977a5b722f2f1'
const RPC_URL = process.env.RPC_URL || 'https://base-sepolia-rpc.publicnode.com'
const CLAIMED_TOPIC = '0x23a14e2ee35b4d16368d22b155c6b5125d622dd4781eae9eb80c9fda30aab9e5'
const START_BLOCK = 38_019_000 // Just before contract deployment
const CHUNK_SIZE = 50_000
const fs = require('fs')

async function rpc(method, params) {
  const res = await fetch(RPC_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ jsonrpc: '2.0', id: 1, method, params })
  })
  const data = await res.json()
  if (data.error) throw new Error(`RPC ${method}: ${data.error.message}`)
  return data.result
}

async function main() {
  const latest = parseInt(await rpc('eth_blockNumber', []), 16)
  console.log(`Scanning blocks ${START_BLOCK} to ${latest}`)

  const allLogs = []
  for (let from = START_BLOCK; from <= latest; from += CHUNK_SIZE) {
    const to = Math.min(from + CHUNK_SIZE - 1, latest)
    const logs = await rpc('eth_getLogs', [{
      address: CONTRACT,
      topics: [CLAIMED_TOPIC],
      fromBlock: '0x' + from.toString(16),
      toBlock: '0x' + to.toString(16)
    }])
    if (logs.length) allLogs.push(...logs)
  }

  console.log(`Found ${allLogs.length} Claimed events`)

  // Claimed event: topic[0]=sig, topic[1]=recipient, data=paperId(32)+emailHash(32)+tokenId(32)
  // Also grab Transfer events for tokenId
  const TRANSFER_TOPIC = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  const claims = []
  for (const log of allLogs) {
    const recipient = '0x' + log.topics[1].slice(26)
    const data = log.data.slice(2) // remove 0x
    const paperId = parseInt(data.slice(0, 64), 16)
    const emailHash = '0x' + data.slice(64, 128)

    // Get tokenId from Transfer event in same tx
    const receipt = await rpc('eth_getTransactionReceipt', [log.transactionHash])
    const transferLog = receipt.logs.find(l => l.topics[0] === TRANSFER_TOPIC)
    const tokenId = transferLog ? transferLog.topics[3] : null

    const block = await rpc('eth_getBlockByNumber', [log.blockNumber, false])
    claims.push({
      paperId,
      recipient,
      emailHash,
      tokenId,
      txHash: log.transactionHash,
      timestamp: new Date(parseInt(block.timestamp, 16) * 1000).toISOString()
    })
  }

  const output = {
    claims,
    claimedPaperIds: [...new Set(claims.map(c => c.paperId))],
    stats: { totalClaims: claims.length },
    updatedAt: new Date().toISOString()
  }

  fs.writeFileSync('claims.json', JSON.stringify(output, null, 2))
  console.log(`Wrote claims.json: ${claims.length} claims`)
}

main().catch(e => { console.error(e); process.exit(1) })
