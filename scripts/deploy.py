import string
from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import (
    deploy_mocks,
    get_account,
    LOCAL_BLOCKCHAIN_ENVIROMENTS,
)


def deploy_fund_me():
    account = get_account()
    # Pass the price feed address to the contract
    # If we are on persistent network like rinkeby, use the associated address
    # otherwise deploy mocks

    netwerk = network.show_active()

    if netwerk not in LOCAL_BLOCKCHAIN_ENVIROMENTS:
        print(f"Actual Network {netwerk}")
        price_feed_address = config["networks"][netwerk]["eth_usd_price_feed"]
    else:
        # print(f"Actual Network {network.show_active()}")
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][netwerk].get("verify"),
    )
    print(f"Contract deployed to {fund_me.address}")


def main():
    deploy_fund_me()
