package fatsqlite

import (
	"bytes"
	"compress/gzip"
	_ "embed"
	"io"

	"github.com/ncruces/go-sqlite3"
)

//go:embed sqlite-vec.wasm.gz
var binary []byte

func init() {

	// uncompress the wasm file
	uncompressed, err := gzip.NewReader(bytes.NewReader(binary))
	if err != nil {
		panic(err)
	}

	uncompressedBytes, err := io.ReadAll(uncompressed)
	if err != nil {
		panic(err)
	}

	sqlite3.Binary = uncompressedBytes
}
