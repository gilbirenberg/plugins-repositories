# Here are samples on how to clone CMA definitions.
# it's used to allow scripts run in multiple modes, each one having it's own CMA screen.
# The example below shows how to clone for Squid monitoring which support 5 different modes.
# Clonses should be checked into perforce so to be picked up for the next build/packaging
# cleanup of created clones is possible using the following command:
#     rm -f $(find . -name Squid_\*_cma.\*)
#
#
../../../../build/clone-cma.sh -s Squid_cma -t Squid_resources_cma -a Arguments -v default="resources -p 3128 /usr/squid"
../../../../build/clone-cma.sh -s Squid_resources_cma -t Squid_resources_cma -a displayName -v displayName="Resources monitor"
../../../../build/clone-cma.sh -s Squid_cma -t Squid_server_cma -a Arguments -v default="server -p 3128 /usr/squid"
../../../../build/clone-cma.sh -s Squid_server_cma -t Squid_server_cma -a displayName -v displayName="Server monitor"
../../../../build/clone-cma.sh -s Squid_cma -t Squid_client_cma -a Arguments -v default="client -p 3128 /usr/squid"
../../../../build/clone-cma.sh -s Squid_client_cma -t Squid_client_cma -a displayName -v displayName="Client monitor"
../../../../build/clone-cma.sh -s Squid_cma -t Squid_icp_cma -a Arguments -v default="icp -p 3128 /usr/squid"
../../../../build/clone-cma.sh -s Squid_icp_cma -t Squid_icp_cma -a displayName -v displayName="ICP monitor"
../../../../build/clone-cma.sh -s Squid_cma -t Squid_syscalls_cma -a Arguments -v default="Syscalls -p 3128 /usr/squid"
../../../../build/clone-cma.sh -s Squid_syscalls_cma -t Squid_syscalls_cma -a displayName -v displayName="System calls monitor"
