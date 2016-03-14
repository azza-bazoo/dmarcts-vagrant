## Vagrant configuration for parsing DMARC reports

This Vagrantfile is a quick way to get set up with a [report parser](https://github.com/techsneeze/dmarcts-report-parser) and [web viewer](https://github.com/techsneeze/dmarcts-report-viewer) for DMARC aggregate reports.

### Quick start

```
$ git clone https://github.com/azza-bazoo/dmarcts-vagrant.git && cd dmarcts-vagrant
```
```
$ vagrant up
```

It may take a while for setup to finish (especially if you don't have the [Ubuntu base box](https://vagrantcloud.com/ubuntu/boxes/trusty64) ready).

Once it's done, run the parser with:

```
$ vagrant ssh
$ ./parser.pl -d /vagrant/MY_MAILBOX_FILE
```

Then visit [http://localhost:8080/dmarcts-report-viewer.php](http://localhost:8080/dmarcts-report-viewer.php) in your browser.

### What's DMARC?

DMARC, the Domain-based Message Authentication, Reporting and Conformance system, helps combat spam by letting admins specify what authentication to expect in mail from their domain.

For more, see the [official FAQ](https://dmarc.org/wiki/FAQ), or [Wikipedia](https://en.wikipedia.org/wiki/DMARC).

If you run your own mail server, it's very much in your interest to [set up DMARC](http://www.gettingemaildelivered.com/how-to-set-up-dmarc-email-authentication) and use the `rua` flag to tell receivers (like Gmail or Yahoo Mail) to send reports back to you on how it's working.

This repository helps you make sense of those reports.

### What's dmarcts-report-parser?

It's a Perl script by [TechSneeze](http://www.techsneeze.com), based on work by [John Levine](http://www.taugh.com/), for taking the XML attachments out of DMARC report files and making sense of them.

It's not all that easy to run the script on a Mac or Windows system, but if you already have Vagrant installed (as many web developers do), this repo provides a `Vagrantfile` and setup script to get you going.

### What do I need to run this?

Just [Vagrant](https://www.vagrantup.com/), which is an easy way to set up virtual machines consistently for development on any host platform. If you haven't used Vagrant before, you'll likely need to install [VirtualBox](https://www.virtualbox.org/) too.
