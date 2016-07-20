import sys
import AppKit as NS

notif = NS.NSUserNotification.alloc().init()
notif.setTitle_("Notify.py")
notif.setInformativeText_(sys.argv[1])
NS.NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification_(notif)
