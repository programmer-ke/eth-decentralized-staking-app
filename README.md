# 🚩 🥩 Decentralized Staking App v2 - simpler state logic

This takes the Decentralized Stacking challenge that is part of the
speedrun and simplifies the state transition logic.

Instead of having state logic spread across multiple modifiers and
state variables, we use a single state variable to track the current
state and execute transition logic based on its value.

We define three states for the Staker: `Opened`, `Completed` &
`OpenForWithdrawals`.

This state will be manipulated by the event handling logic for each
of the three events: `stake`, `execute` and `withdraw`.

This results in easier to reason about logic that is less error prone.

NB: For local dev, we need to generate blocks manually in some cases.
Triggering the `generateBlocks` method from the Debug Contract tab
will help with this.

The rest of the description follows.

![readme-1](https://github.com/scaffold-eth/se-2-challenges/assets/80153681/a620999a-a1ff-462d-9ae3-5b49ab0e023a)

🦸 A superpower of Ethereum is allowing you, the builder, to create a
simple set of rules that an adversarial group of players can use to
work together. In this challenge, you create a decentralized
application where users can coordinate a group funding effort. If the
users cooperate, the money is collected in a second smart contract. If
they defect, the worst that can happen is everyone gets their money
back. The users only have to trust the code.

🏦 Build a `Staker.sol` contract that collects **ETH** from numerous
addresses using a payable `stake()` function and keeps track of
`balances`. After some `deadline` if it has at least some `threshold`
of ETH, it sends it to an `ExampleExternalContract` and triggers the
`complete()` action sending the full balance. If not enough **ETH** is
collected, allow users to `withdraw()`.

🎛 Building the frontend to display the information and UI is just as
important as writing the contract. The goal is to deploy the contract
and the app to allow anyone to stake using your app. Use a
`Stake(address,uint256)` event to list all stakes.

🌟 The final deliverable is deploying a Dapp that lets users send
ether to a contract and stake if the conditions are met, then `yarn
vercel` your app to a public webserver. Submit the url on
[SpeedRunEthereum.com](https://speedrunethereum.com)!

### ⚠️ Test it!

- Run `yarn test` to run the automated testing function. It will test
  that you hit the core checkpoints. You are looking for all green
  checkmarks and passing tests!

---

##  💾 Deploy your contract! 🛰

📡 Edit the `defaultNetwork` to [your choice of public EVM networks](https://ethereum.org/en/developers/docs/networks/) in `packages/hardhat/hardhat.config.ts`

🔐 You will need to generate a **deployer address** using `yarn generate` This creates a mnemonic and saves it locally.

👩‍🚀 Use `yarn account` to view your deployer account balances.

⛽️ You will need to send ETH to your deployer address with your wallet, or get it from a public faucet of your chosen network.

> 📝 If you plan on submitting this challenge, be sure to set your `deadline` to at least `block.timestamp + 72 hours`

🚀 Run `yarn deploy` to deploy your smart contract to a public network (selected in `hardhat.config.ts`)

> 💬 Hint: You can set the `defaultNetwork` in `hardhat.config.ts` to `sepolia` **OR** you can `yarn deploy --network sepolia`.

![allStakings-blockFrom](https://github.com/scaffold-eth/se-2-challenges/assets/55535804/04725dc8-4a8d-4089-ba82-90f9b94bfbda)

> 💬 Hint: For faster loading of your _"Stake Events"_ page, consider updating the `fromBlock` passed to `useScaffoldEventHistory` in [`packages/nextjs/pages/stakings.tsx`](https://github.com/scaffold-eth/se-2-challenges/blob/challenge-1-decentralized-staking/packages/nextjs/pages/stakings.tsx) to `blocknumber - 10` at which your contract was deployed. Example: `fromBlock: 3750241n` (where `n` represents its a [BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)). To find this blocknumber, search your contract's address on Etherscan and find the `Contract Creation` transaction line.

---

## 🚢 Ship your frontend! 🚁

✏️ Edit your frontend config in `packages/nextjs/scaffold.config.ts` to change the `targetNetwork` to `chains.sepolia` or any other public network.

💻 View your frontend at http://localhost:3000/stakerUI and verify you see the correct network.

📡 When you are ready to ship the frontend app...

📦 Run `yarn vercel` to package up your frontend and deploy.

> Follow the steps to deploy to Vercel. Once you log in (email, github, etc), the default options should work. It'll give you a public URL.

> If you want to redeploy to the same production URL you can run `yarn vercel --prod`. If you omit the `--prod` flag it will deploy it to a preview/test URL.

> 🦊 Since we have deployed to a public testnet, you will now need to connect using a wallet you own or use a burner wallet. By default 🔥 `burner wallets` are only available on `hardhat` . You can enable them on every chain by setting `onlyLocalBurnerWallet: false` in your frontend config (`scaffold.config.ts` in `packages/nextjs/`)

#### Configuration of Third-Party Services for Production-Grade Apps.

By default, 🏗 Scaffold-ETH 2 provides predefined API keys for popular services such as Alchemy and Etherscan. This allows you to begin developing and testing your applications more easily, avoiding the need to register for these services.  
This is great to complete your **SpeedRunEthereum**.

For production-grade applications, it's recommended to obtain your own API keys (to prevent rate limiting issues). You can configure these at:

- 🔷`ALCHEMY_API_KEY` variable in `packages/hardhat/.env` and `packages/nextjs/.env.local`. You can create API keys from the [Alchemy dashboard](https://dashboard.alchemy.com/).

- 📃`ETHERSCAN_API_KEY` variable in `packages/hardhat/.env` with your generated API key. You can get your key [here](https://etherscan.io/myapikey).

> 💬 Hint: It's recommended to store env's for nextjs in Vercel/system env config for live apps and use .env.local for local testing.

---

## 📜 Contract Verification

Run the `yarn verify --network your_network` command to verify your contracts on etherscan 🛰

---

> 🏃 Head to your next challenge [here](https://speedrunethereum.com).

> 💬 Problems, questions, comments on the stack? Post them to the
[🏗 scaffold-eth developers chat](https://t.me/joinchat/F7nCRK3kI93PoCOk)
