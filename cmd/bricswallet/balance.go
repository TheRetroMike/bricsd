package main

import (
	"context"
	"fmt"

	"github.com/brics18/bricsd/cmd/bricswallet/daemon/client"
	"github.com/brics18/bricsd/cmd/bricswallet/daemon/pb"
	"github.com/brics18/bricsd/cmd/bricswallet/utils"
)

func balance(conf *balanceConfig) error {
	daemonClient, tearDown, err := client.Connect(conf.DaemonAddress)
	if err != nil {
		return err
	}
	defer tearDown()

	ctx, cancel := context.WithTimeout(context.Background(), daemonTimeout)
	defer cancel()
	response, err := daemonClient.GetBalance(ctx, &pb.GetBalanceRequest{})
	if err != nil {
		return err
	}

	pendingSuffix := ""
	if response.Pending > 0 {
		pendingSuffix = " (pending)"
	}
	if conf.Verbose {
		pendingSuffix = ""
		println("Address                                                                       Available             Pending")
		println("-----------------------------------------------------------------------------------------------------------")
		for _, addressBalance := range response.AddressBalances {
			fmt.Printf("%s %s %s\n", addressBalance.Address, utils.FormatKas(addressBalance.Available), utils.FormatKas(addressBalance.Pending))
		}
		println("-----------------------------------------------------------------------------------------------------------")
		print("                                                 ")
	}
	fmt.Printf("Total balance, BRICS %s %s%s\n", utils.FormatKas(response.Available), utils.FormatKas(response.Pending), pendingSuffix)

	return nil
}
