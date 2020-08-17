#!/usr/bin/env python2.7
import os
import subprocess

DEBUG = False

_build_dir_cache = {}


def find_dir(path, predicate):
    # Takes absolute paths

    if predicate(path):
        return path

    parent = os.path.dirname(path)
    if path == parent:
        raise Exception("No matching path found.")

    return find_dir(parent, predicate)


def find_repo_root():
    def _is_repo_root(p):
        return os.path.isdir(os.path.join(p, '.git'))

    return find_dir(os.getcwd(), _is_repo_root)


def find_build_dir(path):
    # Takes absolute paths

    def _is_build_dir(p):
        try:
            return _build_dir_cache[p]
        except KeyError:
            result = (
                os.path.isfile(os.path.join(p, 'BUILD')) or
                os.path.isfile(os.path.join(p, 'BUILD.in'))
            )
            _build_dir_cache[p] = result
            return result

    return find_dir(path, _is_build_dir)


def get_changed_files(repo_root):
    # Returns absolute paths

    # Get the base commit, according to arc
    arc_cmd = ['arc', 'which', '--show-base']
    arc_stdout = subprocess.check_output(arc_cmd, cwd=repo_root).strip()

    # Get files that were changed since the base commit (including tracked files that aren't yet committed)
    git_cmd = ['git', 'diff', '--name-only', '--diff-filter=uxb', '-r', '-z', arc_stdout]
    git_stdout = subprocess.check_output(git_cmd, cwd=repo_root).strip()

    modified_files = [p for p in git_stdout.split('\00') if p]
    if DEBUG:
        print "modified_files={}".format(modified_files)

    # Get untracked files
    git_cmd = ['git', 'ls-files', '--others', '--exclude-standard']
    git_stdout = subprocess.check_output(git_cmd, cwd=repo_root).strip()

    untracked_files = [p for p in git_stdout.split('\n') if p]
    if DEBUG:
        print "untracked_files={}".format(untracked_files)

    return [os.path.join(repo_root, p) for p in modified_files + untracked_files]


def get_bzl_packages_for_files(paths, repo_root):
    # Takes absolute paths

    build_dirs = {find_build_dir(f) for f in paths}
    rel_dirs = [os.path.relpath(d, repo_root) for d in build_dirs]
    return sorted(["//{}".format(d) for d in rel_dirs if d != '.'])


def bzl_gen_packages(packages):
    mbzl_cmd = ['mbzl', 'gen', '-v', '--']
    mbzl_cmd += packages
    
    print '+ ' + ' '.join(mbzl_cmd)
    subprocess.check_call(mbzl_cmd)


if __name__ == '__main__':
    repo_root = find_repo_root()
    if DEBUG:
        print "repo_root={}".format(repo_root)

    changed_files = get_changed_files(repo_root)
    if DEBUG:
        print "changed_files={}".format(changed_files)

    packages = get_bzl_packages_for_files(changed_files, repo_root)
    if DEBUG:
        print "packages={}".format(packages)

    bzl_gen_packages(packages)
