! Purpose: Solve periodic shifted Poisson problem with spectral method

program bvp
  use utility, only: fp, pi
  use dft, only: matvecprod, dft_InvTransMat, dft_TransMat
  use problemsetup, only: N, outFile, exact_sol, forcing, problemsetup_Init

  implicit none

  ! Problem data
  real (fp) :: dx                             ! Grid point spacing
  real (fp), allocatable :: x(:), k(:)        ! Physical domain, wave domain
  real (fp), allocatable :: u(:), f(:), ft(:) ! Solution, forcing, transformed forcing
  real (fp), allocatable :: T(:,:), Tinv(:,:)   ! Transformation matrices
  ! Loop variables
  integer :: i, status

  ! Report out the selected kind for reals
  print "(' Selected real kind: fp = ',i2)", fp

  ! Read initialization file
  call problemsetup_Init('bvp.init')

  ! Allocate space for all problem data
  call allocate_data()

  dx = (2.0_fp * pi) / N
  do  i = 1, N
     x(i) = (i-1) * dx
  end do
  f = forcing(x)

  call dft_TransMat(x, k, T)

  call dft_InvTransMat(x, k, Tinv)

  ft = matvecprod(T, f)

  ft = ft/(1+k**2)

  u = matvecprod(Tinv, ft)
  print *, "Err: ", calculate_error()

  ! Open the output file and write the columns
  call write_data()

  ! Deallocate everything to clean up
  call deallocate_data()

contains

  function calculate_error() result(err)
    implicit none
    real (fp) :: err
    err = maxval( abs( u - exact_sol(x) ) )
  end function calculate_error

  subroutine allocate_data()
    implicit none
    allocate(x(N))
    allocate(k(N))
    allocate(u(N))
    allocate(f(N))
    allocate(ft(N))
    allocate(T(N,N))
    allocate(Tinv(N,N))
  end subroutine allocate_data

  subroutine deallocate_data()
    implicit none
    deallocate(x)
    deallocate(k)
    deallocate(u)
    deallocate(f)
    deallocate(ft)
    deallocate(T)
    deallocate(Tinv)
  end subroutine deallocate_data

  subroutine write_data()
    implicit none
    print *, 'Writing file: ', outFile
    call execute_command_line('mkdir -p data', exitstat=status)
    if (status /= 0) error stop 'Cannot create data directory'
    open(20,file=outFile,status="replace",iostat=status)
    if (status /= 0) error stop 'Cannot open solution output'
    do i=1,N
      write(20,*) x(i), u(i), f(i), ft(i)
    end do
    close(20)
  end subroutine write_data

end program bvp
