
#!/bin/bash
PS3='NAP Demo Setup - please choose an option:'
choices=("Cleanup" "Start NAP with default signatures" "Pull Update logs from default NAP" "Create image with updated NAP signatures and TC" "Kill default NAP and start updated NAP" "Pull Update logs from updated NAP" "Quit")
select fav in "${choices[@]}"; do
    case $fav in
        "Cleanup")
            echo "Cleaning up container environment"
            docker rmi -f app-protect:tc
            docker kill app-protect-tc
            docker rm app-protect-tc
            docker kill app-protect-default
            docker rm app-protect-default
            break
            ;;
        "Start NAP with default signatures")
            echo "Starting NGINX reverse proxy with NAP, default signatures, no TC"
                  docker build -t app-protect:nosig .
	          docker run -dit --name app-protect-default -p 80:80 -v ~/napscripted/nginx.conf:/etc/nginx/nginx.conf app-protect:nosig
            break
            ;;
        "Pull Update logs from default NAP")
            echo "Revision Date shows release date of signature file"
	          docker exec -it app-protect-default more /var/log/nginx/error.log > revision.txt
                  grep 'revision_datetime' revision.txt
	          break
            ;;
        "Create image with updated NAP signatures and TC")
            echo "Downloading lates NAP engine, signatures and TC"
            docker build -t app-protect:tc -f Dockerfile-sig-tc .
            break
            ;;
        "Kill default NAP and start updated NAP")
            echo "Killing existing NAP, starting new NAP"
            docker kill app-protect-default
            docker run -dit --name app-protect-tc -p 80:80 -v ~/napscripted/nginx.conf:/etc/nginx/nginx.conf app-protect:tc
            break
            ;;
        "Pull Update logs from updated NAP")
            echo "Revision Date shows release date of signature file"
            docker exec -it app-protect-tc more /var/log/nginx/error.log > revision.txt
            grep 'revision_datetime' revision.txt
            exit
            ;;
	"Quit")
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
