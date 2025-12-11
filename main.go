package fatsqlite

import (
	_ "embed"

	"github.com/ncruces/go-sqlite3"
)

//go:embed sqlite-vec.wasm
var binary []byte

func init() {
	sqlite3.Binary = binary
}
