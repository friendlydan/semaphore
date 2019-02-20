package main

import (
	"github.com/kamilsk/go-kit/pkg/fn"
	"github.com/spf13/cobra"
)

const (
	bashFormat = "bash"
	zshFormat  = "zsh"
)

// Completion prints Bash or Zsh completion.
var Completion = &cobra.Command{
	Use:   "completion",
	Short: "Print Bash or Zsh completion",
	RunE: func(cmd *cobra.Command, args []string) error {
		root := cmd
		for {
			if !root.HasParent() {
				break
			}
			root = root.Parent()
		}
		if cmd.Flag("format").Value.String() == bashFormat {
			return root.GenBashCompletion(cmd.OutOrStdout())
		}
		return root.GenZshCompletion(cmd.OutOrStdout())
	},
}

func init() {
	Completion.Flags().StringVarP(new(string), "format", "f", zshFormat, "output format, one of: bash|zsh")
	fn.Must(func() error { return Completion.MarkFlagRequired("format") })
}
