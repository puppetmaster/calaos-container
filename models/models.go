package models

import (
	"context"
	"fmt"
	"os"

	logger "github.com/calaos/calaos-container/log"

	"github.com/sirupsen/logrus"

	"github.com/containers/podman/v4/pkg/bindings"
	"github.com/containers/podman/v4/pkg/bindings/images"
	"github.com/coreos/go-systemd/v22/dbus"
)

var (
	logging *logrus.Entry
)

func init() {
	logging = logger.NewLogger("database")
}

// Init models
func Init() (err error) {

	return
}

// Shutdown models
func Shutdown() {

}

/*
 Podman API Docs:
 https://pkg.go.dev/github.com/containers/podman/v4@v4.5.1/pkg/bindings#section-readme
*/

func Pull(image string) (err error) {
	conn, err := bindings.NewConnection(context.Background(), "unix://run/podman/podman.sock")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	_, err = images.Pull(conn, "ghcr.io/calaos/calaos_home", nil)
	if err != nil {
		fmt.Println(err)
	}

	return err
}

func StopUnit(unit string) (err error) {
	conn, err := dbus.NewWithContext(context.Background())
	defer conn.Close()

	_, err = conn.StopUnitContext(context.Background(), unit, "replace", nil)

	return err
}
