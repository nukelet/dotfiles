my_email = "vinicius.peixoto@canonical.com"
status, mypass = pipe_from('secret-tool lookup mail canonical')
options.recover = "all"

-- Use the configuration below if you opted-in for gmail

canonical = IMAP {
    server = "imap.gmail.com",
    username = "vinicius.peixoto@canonical.com",
    password = mypass,
    ssl = "tls1.2"
}

-- Use the configuration below if you opted-out of gmail
-- canonical = IMAP {
--     server = "mail.canonical.com",
--     username = "your_imap_username",
--     password = mypass,
--     ssl = "tls1.2"
-- }

-- Canonical

function filter_mailing_list(list_email, dest)
    -- Generic function to move all list email that is not directly To: or
    -- Cc: to us
    results = (
        canonical.INBOX:contain_from(list_email) +
        canonical.INBOX:contain_cc(list_email) +
        canonical.INBOX:contain_to(list_email) -
        canonical.INBOX:contain_to(my_email) -
        canonical.INBOX:contain_cc(my_email)
    )
    results:move_messages(canonical[dest])
end

function filter_mailing_list_ubuntu(list_name)
    list_email = list_name .. "@lists.ubuntu.com"
    filter_mailing_list(list_email, list_name)
end

function filter_mailing_list_canonical(list_name)
    list_email = list_name .. "@lists.canonical.com"
    filter_mailing_list(list_email, list_name)
end

function filter()
    -- Kernel team bot
    results = canonical.INBOX:contain_from("kernel-team-bot@canonical.com")
    results:mark_seen()
    results:move_messages(canonical['kernel-team-bot'])

    -- Canonical/Ubuntu mailing lists
    filter_mailing_list_ubuntu("ubuntu-release")
    filter_mailing_list_ubuntu("ubuntu-devel")
    filter_mailing_list_ubuntu("kernel-team")
    filter_mailing_list_canonical("canonical-kernel-team")
    filter_mailing_list_canonical("canonical-kernel-esm")
    filter_mailing_list_canonical("cloud")
    filter_mailing_list_canonical("kernel-crew")

    -- JIRA
    results = canonical.INBOX:contain_from("warthogs.atlassian.net")
    results:move_messages(canonical["Jira"])

    -- kteam-tools
    results = canonical.INBOX:contain_from("noreply+forgejo-bot@canonical.com")
    results:move_messages(canonical["kteam-tools"])

    -- Launchpad
    results = (
        canonical.INBOX:contain_from("bugs.launchpad.net") +
        canonical.INBOX:contain_from("code.launchpad.net") +
        canonical.INBOX:contain_from("noreply@launchpad.net")
    )
    results:mark_seen()
    results:move_messages(canonical["Launchpad"])

    -- Github
    results = canonical.INBOX:contain_from("notifications@github.com")
    results:move_messages(canonical["github"])
end

filter()

-- The following allows for permanent filtering. If you prefer to launch
-- imapfilter periodically using a cron job or manually, remove these
-- lines.
while true do
    canonical.INBOX:enter_idle()
    filter()
end
