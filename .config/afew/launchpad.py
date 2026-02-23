import logging
import sys
from afew.filters.BaseFilter import Filter
from afew.FilterRegistry import register_filter
from notmuch2 import NullPointerError

def get_header(message, header):
    try:
        header = message.header(header)
    except (LookupError, NullPointerError):
        header = None
    return header

def is_lp_spam(message) -> bool:
    lp_notif_type = get_header(message, "X-Launchpad-Notification-Type")
    logging.debug(lp_notif_type)

    if lp_notif_type in ("ci-build-status", "package-build-status"):
        return True

    if lp_notif_type != "bug":
        return False

    message_for = get_header(message, "X-Launchpad-Message-For")
    logging.debug(f"X-Launchpad-Message-For: {message_for}")
    if message_for == "nvidia-modules-private":
        return True
    if message_for == "canonical-kernel-team":
        lp_bug_tags = get_header(message, "X-Launchpad-Bug-Tags")
        logging.debug(f"X-Launchpad-Bug-Tags: {lp_bug_tags}")
        if lp_bug_tags is not None and "kernel-release-tracking-bug" in lp_bug_tags:
            return True

    return False

@register_filter
class LaunchpadFilter(Filter):
    message = "Create tags to separate the noise from important Launchpad notifications"
    query = "tag:canonical"

    def handle_message(self, message):
        if not message:
            return

        if get_header(message, "X-Launchpad-Notification-Type") is None:
            return

        self.add_tags(message, "launchpad")
        if is_lp_spam(message):
            self.add_tags(message, "launchpad-spam")
        else:
            self.add_tags(message, "launchpad-bug")
