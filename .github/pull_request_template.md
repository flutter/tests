<!--
Thanks for filing a pull request!
Reviewers are typically assigned within a week of filing a request.
To learn more about code review, see our documentation on Tree Hygiene: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
-->

*Replace this description with a description of what your PR is changing, adding, enabling, or disabling.*

> [!IMPORTANT]
> This repository is a testing suite that contains references to tests (in the `registry` directory) that are run with every commit to Flutter
> to verify that no breaking changes have been introduced (in the "customer_testing" shards). Your merged PR is _not_ automatically run in the
> Flutter CI tree.
>
> After merging this PR, you must send another PR to flutter/flutter updating `dev/customer_testing/tests.version` in that repo with the latest git commit SHA of the flutter/test repo.
>
> See <https://github.com/flutter/flutter/pull/162048> for details.

## Pre-launch Checklist

- [ ] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [ ] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [ ] I read the [Flutter Style Guide] _recently_, and have followed its advice.
- [ ] I signed the [CLA].
- [ ] I listed at least one issue that this PR fixes in the description above.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] I added new tests to check the change I am making, or this PR is [test-exempt].
- [ ] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/master/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/master/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/master/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/master/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/master/docs/contributing/Chat.md
