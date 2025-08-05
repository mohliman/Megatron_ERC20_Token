// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

contract TestToken is Test{

    DeployToken public deployer;
    ERC20Token public token;

    address bob   = makeAddr("bob");
    address alice = makeAddr("alice");
    address eve   = makeAddr("eve");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployToken();
        token = deployer.run();

        // Give Bob some tokens
        vm.prank(msg.sender); // token owner
        token.transfer(bob, STARTING_BALANCE);
    }

    /* --- ✅ BALANCE TESTS --- */
    function testBobBalance() public view {
        assertEq(token.balanceOf(bob), STARTING_BALANCE);
    }

    function testInitialTotalSupply() public view {
        uint256 supply = token.totalSupply();
        assertEq(supply, 1000 ether); // from your INITIAL_SUPPLY in DeployToken
    }

    /* --- ✅ TRANSFER TESTS --- */
    function testTransferReducesSenderBalance() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        token.transfer(alice, amount);

        assertEq(token.balanceOf(bob), STARTING_BALANCE - amount);
        assertEq(token.balanceOf(alice), amount);
    }

    function testTransferFailsIfInsufficientBalance() public {
        uint256 amount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        vm.expectRevert();
        token.transfer(alice, amount);
    }

    /* --- ✅ ALLOWANCE TESTS --- */
    function testApproveAndTransferFrom() public {
        uint256 initialAllowance = 50 ether;
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        token.approve(alice, initialAllowance);

        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount);

        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(token.balanceOf(alice), transferAmount);
    }

    function testTransferFromFailsIfAllowanceTooLow() public {
        uint256 allowanceAmount = 10 ether;
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        token.approve(alice, allowanceAmount);

        vm.prank(alice);
        vm.expectRevert();
        token.transferFrom(bob, alice, transferAmount);
    }

    function testAllowanceReducesAfterTransferFrom() public {
        uint256 allowanceAmount = 40 ether;
        uint256 transferAmount = 15 ether;

        vm.prank(bob);
        token.approve(alice, allowanceAmount);

        vm.prank(alice);
        token.transferFrom(bob, eve, transferAmount);

        assertEq(token.allowance(bob, alice), allowanceAmount - transferAmount);
    }

    /* --- ✅ EDGE CASE TESTS --- */
    function testCannotTransferToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        token.transfer(address(0), 1 ether);
    }

    function testCannotApproveToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        token.approve(address(0), 1 ether);
    }
}
