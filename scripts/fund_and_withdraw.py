from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    print(fund_me)
    account = get_account()
    price = fund_me.getPrice()
    entrance_fee = fund_me.getEntranceFee()
    print(f"Entrance fee: {entrance_fee}")
    print(f"Price: {price}")
    print("Funding...")
    fund_me.fund({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    print("Hasta acá llegué")
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()
