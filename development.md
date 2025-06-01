# Development notes

## Releasing new versions

```sh
git commit -a
git tag v420.69.666
git push origin HEAD --tags
```

## Documentation

**We must build `site/data/docs.json` on a machine running Hammerspoon and commit it to the repo.**

This is required for API documentation, which is generated using Hammerspoon's regular tooling.
[Process described here](https://me.micahrl.com/blog/hammerspoon-docs-content-adapter/).

```sh
make site/data/docs.json
git add site/data/docs.json
git commit
```
