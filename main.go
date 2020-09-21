package main

import (
	"fmt"
	"log"
	"os"

	pasapi "github.com/infamousjoeg/pas-api-go/pkg/api"
)

var (
	hostname = os.Getenv("PAS_HOSTNAME")
	username = os.Getenv("PAS_USERNAME")
	password = os.Getenv("PAS_PASSWORD")
	authType = os.Getenv("PAS_AUTH_TYPE")
)

func main() {
	// Verify PAS REST API Web Services
	resVerify, errVerify := pasapi.ServerVerify(hostname)
	if errVerify != nil {
		log.Fatalf("Verification failed. %s", errVerify)
	}
	fmt.Printf("Verify JSON:\r\n%s\r\n\r\n", resVerify)

	// Logon to PAS REST API Web Services
	token, errLogon := pasapi.Logon(hostname, username, password, authType, false)
	if errLogon != nil {
		log.Fatalf("Authentication failed. %s", errLogon)
	}
	fmt.Printf("Session Token:\r\n%s\r\n\r\n", token)

	// Logoff PAS REST API Web Services
	success, errLogoff := pasapi.Logoff(hostname, token)
	if errLogoff != nil || success != true {
		log.Fatalf("Logoff failed. %s", errLogoff)
	}
	fmt.Println("Successfully logged off PAS REST API Web Services.")
}
