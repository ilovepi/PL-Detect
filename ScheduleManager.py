from __future__ import absolute_import
from __future__ import with_statement

import random
from datetime import datetime, date, time, timedelta
from dateutil import parser
from io import open
from itertools import izip
import csv


class ScheduleMaker(object):
    u"""Creates schedules for use in automation tasks.

    The schedules created should have no conflicts
    between tasks, i.e. tasks only appear once in a
    Period and only one task may appear in an Interval.

    Periods denote how often a task should be scheduled,
    and limit the number of tasks that can be executed
    for a particular target IP address.
    Intervals denote the maximum running time for a task,
    and also limit the number of target IP addresses that
    can be used.
    """

    def __init__(self, ip_file, start_date, end_date, period, interval, command):
        u""" initializes the class
            :param ip_file: (string) file name of a fil that contains a list of remote host IP addresses, one per line
            :param start_date: (date) provides the date when scheduling starts
            :param end_date: (date) provides the date when scheduling ends
            :param period: (timedelta) The interval at which a test should be run again for same IP
            :param interval: (timedelta) The maximum length of a test, limits how many tests per Period
            :param command: (string) the command string to be run on the remote host. e.g. echo 'hello world!'
            :return:
        """
        self.ip_file = ip_file
        self.start_date = start_date
        self.end_date = end_date
        self.period = period
        self.interval = interval
        self.command = command

        with open(ip_file) as f:
            self.target_list = f.read().splitlines()

        self.output_file_name = u"schedule.txt"

    def create_schedule(self, use_random=False, seed=None):
        days = list(per_delta(self.start_date, self.end_date, timedelta(days=1)))
        with open(self.output_file_name, u'w') as outFile:
            for day in days:
                self.write_day(self.schedule_day(day, use_random, seed), outFile)

    def schedule_day(self, my_date, use_random, seed):
        day = {}
        d = datetime.combine(my_date, time(0, 0))
        if seed is not None:
            random.seed(seed)

        for period in per_delta(d, (d + timedelta(days=1)), self.period):
            # sample get me a random sample of the minutes in an hour ... up to 60
            # instead of putting that in the dictionary, we should put an actual date time
            # we should also pass in the day's date, and remove logic to make times consistent for the whole day
            # datetime removes a great deal of that calculation

            if use_random:
                schedule = random.sample(list(per_delta(period, (period + self.period), self.interval)),
                                         len(self.target_list))
            else:
                schedule = list(per_delta(period, (period + self.period), self.interval))[: len(self.target_list)]

            day.update(dict(izip(schedule, self.target_list)))

        return day

    def write_day(self, day, outFile):
        u"""Write the schedule for the day to a file
            :param day: The day to Schedule
            :param outFile: the file to write to
        """

        items = [(k, v) for k, v in day.items()]
        items.sort()
        for line in items:
            string = u"{0}\t{1:15s}\t{2:s}\n".format(line[0].strftime(u"%H:%M %Y-%m-%d"), line[1], self.command)
            outFile.write(string)


# taken from http://stackoverflow.com/questions/10688006/generate-a-list-of-datetimes-between-an-interval-in-python
def per_delta(start, end, delta):
    """generator that yields the next interval between [start, end], incremented by delta
        :param start: The starting point for the interval
        :param end: The end of the interval
        :param delta: The size of the interval
    """
    curr = start
    while curr < end:
        yield curr
        curr += delta


if __name__ == u"__main__":
    start_date = None
    end_date = None
    period = 5
    duration = 1
    script_name = ""

    with open('schedule.conf', 'r') as f:
        next(f)  # skip headings
        reader = csv.reader(f, delimiter='\t')
        for s_date, e_date, period, duration, script in reader:
            start_date = parser.parse(s_date)
            end_date = parser.parse(e_date)
            period = int(period)
            duration = int(duration)
            script_name = script

    scheduler = ScheduleMaker(u"target_ip.conf", start_date, end_date, timedelta(hours=period),
                              timedelta(minutes=duration), script_name)
    scheduler.create_schedule(False, 0)
