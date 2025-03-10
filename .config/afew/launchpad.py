import logging
from afew.filters.BaseFilter import Filter
from afew.FilterRegistry import register_filter

def is_lp_spam(message) -> bool:
    message_for = message.get_header("X-Launchpad-Message-For")
    logging.debug(f"X-Launchpad-Message-For: {message_for}")
    if message_for == "canonical-kernel-team":
        lp_bug_tags = message.get_header("X-Launchpad-Bug-Tags")
        logging.debug(f"X-Launchpad-Bug-Tags: {lp_bug_tags}")
        if "kernel-release-tracking-bug" in lp_bug_tags:
            return True

        lp_notif_type = message.get_header("X-Launchpad-Notification-Type")
        logging.debug(f"X-Launchpad-Notification-Type")
        if "ci-build-status" in lp_notif_type or "package-build-status" in lp_notif_type:
            return True

    return False

@register_filter
class LaunchpadFilter(Filter):
    message = "Create tags to separate the noise from important Launchpad notifications"
    query = "tag:canonical"


    def handle_message(self, message):
        if message.get_header("X-Launchpad-Notification-Type") != "bug":
            return

        self.add_tags(message, "launchpad")
        if is_lp_spam(message):
            self.add_tags(message, "launchpad-spam")
        else:
            self.add_tags(message, "launchpad-bug")
