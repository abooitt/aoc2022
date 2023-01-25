BEGIN {
  total=0
  ai=0
  numair=0
  air["x"]=0
  delete air["x"]
  numc=3
  j=0
  while (j++ < numc) {
    maxc[j]=0
    minc[j]=1e12
  }
}
{
  numc=split($0,a,/,/)
  i=0
  ind=""
  while (i++ < numc) {
    cube[NR][i]=int(a[i])
    ind = sprintf("%s(%s)",ind,a[i])
    if (a[i] > maxc[i]) {
      maxc[i]=a[i]
    }
    if (a[i] < minc[i]) {
      minc[i]=a[i]
    }
  }
  printf("Lava at %s\n",ind)
  total+=numc*2
  type[ind]="lava"
  lava[ind]=NR
  if (ind in air) {
    delete aircube[air[ind]]
    delete air[ind]
    numair--
  }
  k=0
  while (k++ < numc*2) {
    o=(k%2)*2-1
    i=int((k+1)/2)
    ind=""
    j=0
    while (j++ < numc) {
      if (j==1) {
        c[j]=(i-1)%numc+1
        b[c[j]]=a[c[j]]+o
      } else {
        c[j]=c[j-1]%numc+1
        b[c[j]]=a[c[j]]
      }
    }
    j=0
    while (j++ < numc) {
      ind=sprintf("%s(%s)",ind,b[j])
    }
    printf("Adjacent cube at %s",ind)
    if (ind in lava) {
      printf(": lava\n")
      total-=2
    } else {
      printf(": air\n")
      if (ind in air) {
        continue
      }
      ai++
      j=0
      while (j++ < numc) {
        aircube[ai][j]=b[j]
      }
      air[ind]=ai
      numair++
    }
  }
}
END {
  printf("Num lava: %d - Num air: %d\n",NR,numair)
  j=0
  while (j++ < numc) {
    printf("minc[%d]=%d maxc[%d]=%d\n",j,minc[j],j,maxc[j])
  }
  printf("Part 1 total:%d\n",total)
  prevnumair=numair+1
  lastround=0
  while (1) {
    totalout=0
    newair=0
    for (aind in air) {
      printf("Aircube %d at %s\n",air[aind],aind)
      j=0
      while (j++ < numc) {
        a[j]=aircube[air[aind]][j]
      }
      numlava=0
      numout=0
      airnum=0
      k=0
      while (k++ < numc*2) {
        o=(k%2)*2-1
        i=int((k+1)/2)
        ind=""
        j=0
        while (j++ < numc) {
          if (j==1) {
            c[j]=(i-1)%numc+1
            b[c[j]]=a[c[j]]+o
          } else {
            c[j]=c[j-1]%numc+1
            b[c[j]]=a[c[j]]
          }
        }
        j=0
        while (j++ < numc) {
          ind=sprintf("%s(%s)",ind,b[j])
        }
        printf("Adjacent cube at %s",ind)
        if (ind in lava) {
          printf(": lava\n")
          numlava++
        } else {
          if (ind in air) {
            printf(": air\n")
            airnum++
          } else {
            inside=0
            j=0
            while (j++ < numc) {
              dir=b[j]-a[j]
              c[j]=b[j]
              if (dir==0) {
                continue
              } else {
                dd=dir
                cc=j
              }
            }
            while (comp(c[cc],minc[cc],maxc[cc],dd)) {
              cind=""
              j=0
              while (j++ < numc) {
                if (j==cc) {
                  c[j]+=dd
                }
                cind=sprintf("%s(%s)",cind,c[j])
              }
              if (cind in air) {
                ai++
                j=0
                while (j++ < numc) {
                  aircube[ai][j]=b[j]
                }
                air[ind]=ai
                numair++
                newair++
                inside=1
                break
              }
            }
            if (inside) {
              printf(": air\n")
              airnum++
            } else {
              printf(": outside\n")
              numout++
            }
          }
        }
      }
      if (numout > 0) {
        delete aircube[air[aind]]
        delete air[aind]
        numair--
      } else {
        if (numlava==6) {
          total-=6
          delete aircube[air[aind]]
          delete air[aind]
          numair--
        }
      }
      totalout+=numout
      if (lastround) {
        total-=numlava
      }
    }
    printf("Aircubes remaining: %d, total decreased to %d, total outside: %d\n",numair,total,totalout)
    if (lastround) {
      break
    }
    if (totalout == 0) {
      lastround=1
    }
  }
  print(total)
}
function comp(v,min,max,d) {
  if (d < 0) {
    if (v >= min) {
      return 1
    } else {
      return 0
    }
  }
  if (d > 0) {
    if (v <= max) {
      return 1
    } else {
      return 0
    }
  }
  if (d==0) {
    printf("ERROR: do not know how to compare\n")
    exit
  }
}
