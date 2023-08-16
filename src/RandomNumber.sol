// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {VRFCoordinatorV2Interface} from "chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import {ConfirmedOwner} from "chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import {console2} from "forge-std/Test.sol";

/* 
    For getting started, refer this [Chainlink README](../../sc-sol/ChainlinkVRF/README.md)
*/
contract RandomNumber is VRFConsumerBaseV2, ConfirmedOwner {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }

    mapping(uint256 => RequestStatus) public s_requests; /* requestId --> requestStatus */
    VRFCoordinatorV2Interface private COORDINATOR;

    // Your subscription ID.
    uint64 private s_subscriptionId;

    // past requests Id.
    uint256[] public requestIds;
    uint256 public lastRequestId;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf/v2/subscription/supported-networks/#configurations
    bytes32 private keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 private callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 private requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 private numWords = 2;

    constructor(uint64 subscriptionId, address coordinatorContract)
        VRFConsumerBaseV2(coordinatorContract)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(coordinatorContract);
        s_subscriptionId = subscriptionId;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() external onlyOwner returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId =
            COORDINATOR.requestRandomWords(keyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, numWords);
        s_requests[requestId] = RequestStatus({randomWords: new uint256[](0), exists: true, fulfilled: false});
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];

        console2.log("Random no.s are:");
        for (uint256 i = 0; i < request.randomWords.length; ++i) {
            console2.log("", request.randomWords[i]);
        }

        return (request.fulfilled, request.randomWords);
    }
}
