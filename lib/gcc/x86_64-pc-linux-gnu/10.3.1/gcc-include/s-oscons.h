/*
------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                  S Y S T E M . O S _ C O N S T A N T S                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2000-2021, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

pragma Style_Checks ("M32766");
--  Allow long lines

*/
/*
--  This package provides target dependent definitions of constant for use
--  by the GNAT runtime library. This package should not be directly with'd
--  by an application program.

--  This file is generated automatically, do not modify it by hand! Instead,
--  make changes to s-oscons-tmplt.c and rebuild the GNAT runtime library.
*/



/*
package System.OS_Constants is

   pragma Pure;
*/
/*

   ---------------------------------
   -- General platform parameters --
   ---------------------------------

   type OS_Type is (Windows, Other_OS);
*/
#define Target_OS                     Other_OS
/*
   pragma Warnings (Off, Target_OS);
   --  Suppress warnings on Target_OS since it is in general tested for
   --  equality with a constant value to implement conditional compilation,
   --  which normally generates a constant condition warning.

*/
#define Target_Name                   "x86_64-pc-linux-gnu"
#define SIZEOF_unsigned_int           4
#define Serial_Port_Descriptor Interfaces.C.int
/*

   -------------------
   -- System limits --
   -------------------

*/
#define IOV_MAX                       1024
#define NAME_MAX                      255
/*

   ---------------------
   -- File open modes --
   ---------------------

*/
#define O_RDWR                        2
#define O_NOCTTY                      256
#define O_NDELAY                      2048
/*

   ----------------------
   -- Fcntl operations --
   ----------------------

*/
#define F_GETFL                       3
#define F_SETFL                       4
/*

   -----------------
   -- Fcntl flags --
   -----------------

*/
#define FNDELAY                       2048
/*

   ----------------------
   -- Ioctl operations --
   ----------------------

*/
#define IOCTL_Req_T Interfaces.C.int
#define FIONBIO                       21537
#define FIONREAD                      21531
/*

   ------------------
   -- Errno values --
   ------------------

   --  The following constants are defined from <errno.h>

*/
#define EAGAIN                        11
#define ENOENT                        2
#define ENOMEM                        12
#define EACCES                        13
#define EADDRINUSE                    98
#define EADDRNOTAVAIL                 99
#define EAFNOSUPPORT                  97
#define EALREADY                      114
#define EBADF                         9
#define ECONNABORTED                  103
#define ECONNREFUSED                  111
#define ECONNRESET                    104
#define EDESTADDRREQ                  89
#define EFAULT                        14
#define EHOSTDOWN                     112
#define EHOSTUNREACH                  113
#define EINPROGRESS                   115
#define EINTR                         4
#define EINVAL                        22
#define EIO                           5
#define EISCONN                       106
#define ELOOP                         40
#define EMFILE                        24
#define EMSGSIZE                      90
#define ENAMETOOLONG                  36
#define ENETDOWN                      100
#define ENETRESET                     102
#define ENETUNREACH                   101
#define ENOBUFS                       105
#define ENOPROTOOPT                   92
#define ENOTCONN                      107
#define ENOTSOCK                      88
#define EOPNOTSUPP                    95
#define EPIPE                         32
#define EPFNOSUPPORT                  96
#define EPROTONOSUPPORT               93
#define EPROTOTYPE                    91
#define ERANGE                        34
#define ESHUTDOWN                     108
#define ESOCKTNOSUPPORT               94
#define ETIMEDOUT                     110
#define ETOOMANYREFS                  109
#define EWOULDBLOCK                   11
#define E2BIG                         7
#define EILSEQ                        84
/*

   ----------------------
   -- Terminal control --
   ----------------------

*/
#define TCSANOW                       0
#define TCIFLUSH                      0
#define IXON                          1024
#define CLOCAL                        2048
#define CRTSCTS                       2147483648
#define CREAD                         128
#define ICANON                        2
#define CBAUD                         4111
#define ECHO                          8
#define ECHOE                         16
#define ECHOK                         32
#define ECHOCTL                       512
#define ECHONL                        64
#define CS5                           0
#define CS6                           16
#define CS7                           32
#define CS8                           48
#define CSTOPB                        64
#define PARENB                        256
#define PARODD                        512
#define B0                            0
#define B50                           1
#define B75                           2
#define B110                          3
#define B134                          4
#define B150                          5
#define B200                          6
#define B300                          7
#define B600                          8
#define B1200                         9
#define B1800                         10
#define B2400                         11
#define B4800                         12
#define B9600                         13
#define B19200                        14
#define B38400                        15
#define B57600                        4097
#define B115200                       4098
#define B230400                       4099
#define B460800                       4100
#define B500000                       4101
#define B576000                       4102
#define B921600                       4103
#define B1000000                      4104
#define B1152000                      4105
#define B1500000                      4106
#define B2000000                      4107
#define B2500000                      4108
#define B3000000                      4109
#define B3500000                      4110
#define B4000000                      4111
/*

   ---------------------------------
   -- Terminal control characters --
   ---------------------------------

*/
#define VINTR                         0
#define VQUIT                         1
#define VERASE                        2
#define VKILL                         3
#define VEOF                          4
#define VTIME                         5
#define VMIN                          6
#define VSWTC                         7
#define VSTART                        8
#define VSTOP                         9
#define VSUSP                         10
#define VEOL                          11
#define VREPRINT                      12
#define VDISCARD                      13
#define VWERASE                       14
#define VLNEXT                        15
#define VEOL2                         16
/*

   -----------------------------
   -- Pseudo terminal library --
   -----------------------------

*/
#define PTY_Library                   "-lutil"
/*

   --------------
   -- Families --
   --------------

*/
#define AF_INET                       2
#define AF_INET6                      10
#define AF_UNIX                       1
#define AF_UNSPEC                     0
/*

   -----------------------------
   -- addrinfo fields offsets --
   -----------------------------

*/
#define AI_FLAGS_OFFSET               0
#define AI_FAMILY_OFFSET              4
#define AI_SOCKTYPE_OFFSET            8
#define AI_PROTOCOL_OFFSET            12
#define AI_ADDRLEN_OFFSET             16
#define AI_ADDR_OFFSET                24
#define AI_CANONNAME_OFFSET           32
#define AI_NEXT_OFFSET                40
/*

   ---------------------------------------
   -- getaddrinfo getnameinfo constants --
   ---------------------------------------

*/
#define AI_PASSIVE                    1
#define AI_CANONNAME                  2
#define AI_NUMERICSERV                1024
#define AI_NUMERICHOST                4
#define AI_ADDRCONFIG                 32
#define AI_V4MAPPED                   8
#define AI_ALL                        16
#define NI_NAMEREQD                   8
#define NI_DGRAM                      16
#define NI_NOFQDN                     4
#define NI_NUMERICSERV                2
#define NI_NUMERICHOST                1
#define NI_MAXHOST                    1025
#define NI_MAXSERV                    32
#define EAI_SYSTEM                    -11
/*

   ------------------
   -- Socket modes --
   ------------------

*/
#define SOCK_STREAM                   1
#define SOCK_DGRAM                    2
#define SOCK_RAW                      3
/*

   -----------------
   -- Host errors --
   -----------------

*/
#define HOST_NOT_FOUND                1
#define TRY_AGAIN                     2
#define NO_DATA                       4
#define NO_RECOVERY                   3
/*

   --------------------
   -- Shutdown modes --
   --------------------

*/
#define SHUT_RD                       0
#define SHUT_WR                       1
#define SHUT_RDWR                     2
/*

   ---------------------
   -- Protocol levels --
   ---------------------

*/
#define SOL_SOCKET                    1
#define IPPROTO_IP                    0
#define IPPROTO_IPV6                  41
#define IPPROTO_UDP                   17
#define IPPROTO_TCP                   6
#define IPPROTO_ICMP                  1
#define IPPROTO_IGMP                  2
#define IPPROTO_IPIP                  4
#define IPPROTO_EGP                   8
#define IPPROTO_PUP                   12
#define IPPROTO_IDP                   22
#define IPPROTO_TP                    29
#define IPPROTO_DCCP                  33
#define IPPROTO_RSVP                  46
#define IPPROTO_GRE                   47
#define IPPROTO_ESP                   50
#define IPPROTO_AH                    51
#define IPPROTO_MTP                   92
#define IPPROTO_BEETPH                94
#define IPPROTO_ENCAP                 98
#define IPPROTO_PIM                   103
#define IPPROTO_COMP                  108
#define IPPROTO_SCTP                  132
#define IPPROTO_UDPLITE               136
#define IPPROTO_MPLS                  137
#define IPPROTO_RAW                   255
/*

   -------------------
   -- Request flags --
   -------------------

*/
#define MSG_OOB                       1
#define MSG_PEEK                      2
#define MSG_EOR                       128
#define MSG_WAITALL                   256
#define MSG_NOSIGNAL                  16384
#define MSG_Forced_Flags              MSG_NOSIGNAL
/*
   --  Flags set on all send(2) calls
*/
/*

   --------------------
   -- Socket options --
   --------------------

*/
#define TCP_NODELAY                   1
#define TCP_KEEPCNT                   6
#define TCP_KEEPIDLE                  4
#define TCP_KEEPINTVL                 5
#define SO_REUSEADDR                  2
#define SO_REUSEPORT                  15
#define SO_KEEPALIVE                  9
#define SO_LINGER                     13
#define SO_BROADCAST                  6
#define SO_SNDBUF                     7
#define SO_RCVBUF                     8
#define SO_SNDTIMEO                   21
#define SO_RCVTIMEO                   20
#define SO_ERROR                      4
#define SO_BUSY_POLL                  46
#define IP_MULTICAST_IF               32
#define IP_MULTICAST_TTL              33
#define IP_MULTICAST_LOOP             34
#define IP_ADD_MEMBERSHIP             35
#define IP_DROP_MEMBERSHIP            36
#define IP_PKTINFO                    8
#define IP_RECVERR                    11
#define IPV6_ADDRFORM                 1
#define IPV6_ADD_MEMBERSHIP           20
#define IPV6_DROP_MEMBERSHIP          21
#define IPV6_MTU                      24
#define IPV6_MTU_DISCOVER             23
#define IPV6_MULTICAST_HOPS           18
#define IPV6_MULTICAST_IF             17
#define IPV6_MULTICAST_LOOP           19
#define IPV6_RECVPKTINFO              49
#define IPV6_PKTINFO                  50
#define IPV6_RTHDR                    57
#define IPV6_AUTHHDR                  10
#define IPV6_DSTOPTS                  59
#define IPV6_HOPOPTS                  54
#define IPV6_FLOWINFO                 -1
#define IPV6_HOPLIMIT                 52
#define IPV6_RECVERR                  25
#define IPV6_ROUTER_ALERT             22
#define IPV6_UNICAST_HOPS             16
#define IPV6_V6ONLY                   26
/*

   ----------------------
   -- Type definitions --
   ----------------------

*/
/*
   --  Sizes (in bytes) of the components of struct timeval
*/
#define SIZEOF_tv_sec                 8
#define SIZEOF_tv_usec                8
/*

   --  Maximum allowed value for tv_sec
*/
#define MAX_tv_sec                    2 ** (SIZEOF_tv_sec * 8 - 1) - 1
/*

   --  Sizes of various data types
*/
#define SIZEOF_sockaddr_in            16
#define SIZEOF_sockaddr_in6           28
#define SIZEOF_sockaddr_un            110
#define SIZEOF_fd_set                 128
#define FD_SETSIZE                    1024
#define SIZEOF_struct_hostent         32
#define SIZEOF_struct_servent         32
#define SIZEOF_sigset                 128
#define SIZEOF_nfds_t                 64
#define SIZEOF_socklen_t              4
#define SIZEOF_fd_type                32
#define SIZEOF_pollfd_events          16
#define IF_NAMESIZE                   -1
/*

   --  Poll values

*/
#define POLLIN                        1
#define POLLPRI                       2
#define POLLOUT                       4
#define POLLERR                       8
#define POLLHUP                       16
#define POLLNVAL                      32
/*

   --  Fields of struct msghdr
*/
#define Msg_Iovlen_T Interfaces.C.size_t
/*

   ----------------------------------------
   -- Properties of supported interfaces --
   ----------------------------------------

*/
#define Need_Netdb_Buffer             1
#define Need_Netdb_Lock               0
#define Has_Sockaddr_Len              0
#define Thread_Blocking_IO            True
/*
   --  Set False for contexts where socket i/o are process blocking

*/
#define Inet_Pton_Linkname            "inet_pton"
#define Inet_Ntop_Linkname            "inet_ntop"
#define Poll_Linkname                 "poll"
/*

   ---------------------
   -- Threads support --
   ---------------------

   --  Clock identifier definitions

*/
#define CLOCK_REALTIME                0
#define CLOCK_MONOTONIC               1
#define CLOCK_THREAD_CPUTIME_ID       3
#define CLOCK_RT_Ada                  CLOCK_MONOTONIC
/*

   --  Sizes of pthread data types
*/
/*

*/
#define PTHREAD_SIZE                  8
#define PTHREAD_ATTR_SIZE             56
#define PTHREAD_MUTEXATTR_SIZE        4
#define PTHREAD_MUTEX_SIZE            40
#define PTHREAD_CONDATTR_SIZE         4
#define PTHREAD_COND_SIZE             48
#define PTHREAD_RWLOCKATTR_SIZE       8
#define PTHREAD_RWLOCK_SIZE           56
#define PTHREAD_ONCE_SIZE             4
/*

   --------------------------------
   -- File and directory support --
   --------------------------------

*/
#define SIZEOF_struct_file_attributes 32
#define SIZEOF_struct_dirent_alloc    275
/*

end System.OS_Constants;
*/
