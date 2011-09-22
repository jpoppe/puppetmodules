#!/usr/bin/env python

"""
rep.py (c) 2010-2011 eBay - written by Jasper Poppe <jpoppe@ebay.com>

"""

import optparse
import os
import pwd
import subprocess

def get_repos(path):
    """create a dictionary with all the repositories"""
    repos = os.listdir(path)
    repos = [repo for repo in repos if os.path.isfile(os.path.join(path, repo, 'conf/distributions'))]
    confs = [os.path.join(path, directory, 'conf/distributions') for directory in repos]

    repositories = {}
    for conf in confs:
        updates_file = os.path.join(conf.rsplit('/', 1)[0], 'updates')
        repo = conf.replace(path, '')[1:].split('/', 1)[0]
        if os.path.isfile(updates_file):
            type = 'mirror'
        else:
            type = 'custom'

        repositories[repo] = {'type': type, 'path': os.path.join(path, repo)}

    return repositories

def get_codenames(repositories):
    """add the codename for each repository to the repositories dictionary"""
    for repo in repositories:
        file = os.path.join(repositories[repo]['path'], 'conf/distributions')
        data = open(file, 'r').read()
        for line in data.split('\n'):
            line = line.split(': ')
            if line[0] == 'Codename':
                if not repositories[repo].has_key('codenames'):
                    repositories[repo]['codenames'] = [line[1]]
                else:
                    repositories[repo]['codenames'].append(line[1])

    return repositories

def add(repositories, add, packages, user='repo'):
    """add a package to a reprepro repository"""
    repo, codename = add
    repo_dir = repositories[repo]['path']

    for package in packages:
        if os.path.isfile(package):
            print ('info: adding "%s" package "%s" to "%s"' % (codename, package, repo))
            #subprocess.call(['sudo', '-u', user, '/usr/bin/reprepro', '-V', '-b', repo_dir, 'includedeb', codename, package])
            subprocess.call(['/usr/bin/reprepro', '-V', '-b', repo_dir, 'includedeb', codename, package])
        else:
            print ('error: package "%s" not found' % package)

def delete(repositories, delete, packages, user='repo'):
    """delete a package from a reprepro repository"""
    repo, codename = delete
    repo_dir = repositories[repo]['path']

    for package in packages:
        print ('info: removing package "%s" from "%s" (%s)' % (package, repo, codename))
        #subprocess.call(['sudo', '-u', user, '/usr/bin/reprepro', '-V', '-b', repo_dir, 'remove', codename, package])
        subprocess.call(['/usr/bin/reprepro', '-V', '-b', repo_dir, 'remove', codename, package])

def contents(name, repo_dir, codename):
    """list the packages in the specified repository"""
    print ('info: listing contents for codename "%s" in repository "%s"' % (codename, name))
    subprocess.call(['/usr/bin/reprepro', '-V', '-b', repo_dir, 'list', codename])

def update(repo, path, user='repo'):
    """sync a mirror"""
    print ('info: fetching updates for repository "%s"' % repo)
    #subprocess.call(['sudo', '-u', user, '/usr/bin/reprepro', '-V', '-b', path, '--noskipold', 'update'])
    subprocess.call(['/usr/bin/reprepro', '-V', '-b', path, '--noskipold', 'update'])
    print ('')

def list_repos(repositories, repo_type):
    """list all available repositories"""
    for key, values in repositories.items():
        if values['type'] == repo_type:
            print ('%s (%s)' % (key, ', '.join(values['codenames'])))

def main():
    """main application, this function won't called when used as a module"""
    parser = optparse.OptionParser(prog='rep.py', version='0.1')
    parser.set_description('rep.py - reprepro manager (c) 2010-2011 eBay - Jasper Poppe <jpoppe@ebay.com>')
    parser.set_usage('%prog -l | [-a|-d <repository> <codename> <package>... | [-c <repository> <codename>] | [-u <repository>]')
    parser.add_option('-l', dest='list_all', help='list available repositories', action='store_true')
    parser.add_option('-a', dest='add', help='add package(s) to a custom repository', nargs=2)
    parser.add_option('-d', dest='delete', help='remove package(s) from a custom repository', nargs=2)
    parser.add_option('-c', dest='contents', help='list the contents of a repository', nargs=2)
    parser.add_option('-u', dest='update', help='update mirror', action='append')
    parser.add_option('-U', dest='user', help='override repository owner (default: repo) (DO NOT USE IN A PRODUCTION ENVIRONMENT)', default='repo')
    parser.add_option('-p', dest='repo_path', help='repository path (default: /opt/repositories/debian)', default='/opt/repositories/debian')
    (opts, args) = parser.parse_args()

    if opts.add or opts.delete or opts.contents or opts.update:
        #if not os.geteuid() == 0:
        if not pwd.getpwuid(os.getuid())[0] == opts.user:
            parser.error('only the "%s" user can modify repositories' % opts.user)
            #parser.error('only a user with root permissions can modify repositories')

    if opts:
        #if opts.user == 'root':
        #    os.environ['HOME'] = '/root' 
        #else:
        #    os.environ['HOME'] = os.path.join('/home', opts.user)
        repositories = get_repos(opts.repo_path)
        repositories = get_codenames(repositories)

    if opts.list_all:
        print ('Custom repositories (you can add debian packages here):')
        list_repos(repositories, 'custom')
        print ('')
        print ('Mirrors:')
        list_repos(repositories, 'mirror')
    elif opts.add:
        if not args:
            parser.error('need to specify at least one package')
        if repositories.has_key(opts.add[0]):
            if repositories[opts.add[0]]['type'] == 'custom':
                #add(repositories, opts.add, args, opts.user)
                add(repositories, opts.add, args)
            else:
                parser.error('"%s" is not a valid and or a custom repository (hint: try -l)' % opts.add)
        else:
            parser.error('repository "%s" not found (hint: try -l)' % opts.add[0])
    elif opts.delete:
        if not args:
            parser.error('need to specify at least one package')
        if repositories.has_key(opts.delete[0]):
            if repositories[opts.delete[0]]['type'] == 'custom':
                #delete(repositories, opts.delete, args, opts.user)
                delete(repositories, opts.delete, args)
            else:
                parser.error('"%s" is not a valid and or a custom repository (hint: try -l)' % opts.delete)
    elif opts.update:
        if len(opts.update) == 0 and opts.update[0] == 'ALL':
            for key, value in repositories.items():
                if value['type'] == 'mirror':
                    update(key, value['path'])
                    #update(key, value['path'], opts.user)
        else:
            for repo in opts.update:
                if repositories.has_key(repo):
                    if repositories[repo]['type'] == 'mirror':
                        #update(repo, repositories[repo]['path'], opts.user)
                        update(repo, repositories[repo]['path'])
                    else:
                        parser.error('"%s" is not a mirror, refusing to update (hint: try -l)' % repo)
                else:
                    parser.error('"%s" is not a valid repository (hint: try -l)' % repo)
    elif opts.contents:
        if args:
            parser.error('the contents option takes no arguments')
        else:
            try:
                contents(opts.contents[0], repositories[opts.contents[0]]['path'], opts.contents[1])
            except KeyError:
                parser.error('%s is not a valid repository, type -l to list all available repositories' % opts.contents[0])
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
