#!/usr/bin/env python

REPOSITORY_NAME='docker-cli-base'
CICA_VERSION = '5.0.3'
GO_VERSION = '1.22.0'
CPU_PERIOD = 100000
CPU_QUOTA = 20000

BASES = ['debian', 'alpine']

import sys

sys.path.append('./vendor')


import argparse

class CLI:
  @classmethod
  def __init__(self):
    self.parser = argparse.ArgumentParser(sys.argv[0])
    self.parser.add_argument('user', help = 'Docker Hub user name')
    self.parser.add_argument('base', choices = BASES, help = f'base distro {BASES}')
    self.parser.add_argument('tag', help = 'Git tag name (ex: 20240218001)')
    self.parser.add_argument('--repository', default = REPOSITORY_NAME, help = f'Docker Hub repository name (default is {REPOSITORY_NAME})')
    self.parser.add_argument('--cica-ver', default = CICA_VERSION, help = f'Cica version (default is {CICA_VERSION})')
    self.parser.add_argument('--go-ver', default = GO_VERSION, help = f'Golang version (default is {GO_VERSION})')
    self.parser.add_argument('--cpu-period', default = CPU_PERIOD, help = f'CPU period (default is {CPU_PERIOD})')
    self.parser.add_argument('--cpu-quota', default = CPU_QUOTA, help = f'CPU quota (default is {CPU_QUOTA})')
    self.args = self.parser.parse_args()


import re
from jinja2 import Template

class Render:
  @classmethod
  def __init__(self, template_file_name):
    self.template_file_name = template_file_name
    self.output_file_name = re.sub(r'\.jinja$', '', template_file_name)

  @staticmethod
  def __read_file(file_name) -> str:
    contents = ''
    with open(file_name, 'r') as file:
      contents = file.read()
      file.close()
    return contents

  @staticmethod
  def __write_file(file_name, contents):
    with open(file_name, 'w') as file:
      file.write(contents)
      file.close()
    pass

  @classmethod
  def render(self, **kwargs):
    template = Template(Render.__read_file(self.template_file_name))
    Render.__write_file(self.output_file_name, template.render(kwargs))
    pass


class Factory:
  @classmethod
  def __init__(self):
    self.cli = CLI()
    pass

  @classmethod
  def __render_build(self):
    render = Render('build.sh.jinja')
    render.render(
      base = self.cli.args.base,
      tag_name = self.cli.args.tag,
      repository = self.cli.args.repository,
      cica_ver = self.cli.args.cica_ver,
      go_ver = self.cli.args.go_ver,
      cpu_period = self.cli.args.cpu_period,
      cpu_quota = self.cli.args.cpu_quota
    )
    pass

  @classmethod
  def __render_push(self):
    render = Render('push.sh.jinja')
    render.render(
      user = self.cli.args.user,
      base = self.cli.args.base,
      tag_name = self.cli.args.tag,
      repository = self.cli.args.repository,
      shorthands = ' '.join([self.cli.args.base])
    )
    pass

  @classmethod
  def produce(self):
    self.__render_build()
    self.__render_push()
    pass


if __name__ == '__main__':
  factory = Factory()
  factory.produce()